#!/bin/zsh
# Run one eval of a skill in a fresh headless Claude Code session, from an empty folder outside
# the repo, so the session cannot read the eval checklist.
#
# usage: scripts/run-eval.sh <skill-name> <eval-file> <out-prefix>
#   skill-name  test-case-design | story-readiness-check | api-test-scenario-generator
#   eval-file   e.g. skills/test-case-design/evals/01-missing-limit.md
#   out-prefix  e.g. /tmp/evals/tcd-01   → writes tcd-01.prompt.txt, tcd-01.json, tcd-01.md
#
# The prompt is only the fenced Input block plus the "Intake answers" paragraph. Never the Must lists.
# The plugin is loaded from this clone with --plugin-dir, so the branch you are on is what runs.
# Afterwards, check the transcript (~/.claude/projects/<cwd-hash>/<session_id>.jsonl) for any
# tool call mentioning "evals/" and discard the run if you find one.

set -e
skill=$1; f=$2; out=$3
[ -n "$skill" ] && [ -f "$f" ] && [ -n "$out" ] || { echo "usage: $0 <skill> <eval-file> <out-prefix>"; exit 1; }
repo=$(cd "$(dirname "$0")/.." && pwd)
f=$(cd "$(dirname "$f")" && pwd)/$(basename "$f")
mkdir -p "$(dirname "$out")"

input=$(awk '/^```/{c=!c; next} c{print}' "$f")
intake=$(awk '/^Intake answers/{p=1} p&&/^$/{exit} p{print}' "$f")
prompt="Use the /ai-tools:${skill} skill.

${input}

${intake}"
print -r -- "$prompt" > "${out}.prompt.txt"

work=$(mktemp -d)
cd "$work"
claude -p "$prompt" --plugin-dir "$repo" --output-format json --allowedTools "Read,Glob,Grep" \
  --max-turns 40 > "${out}.json" 2> "${out}.err" || true
python3 - "$out" <<'EOF'
import json, sys
out = sys.argv[1]
try:
    d = json.load(open(out + '.json'))
except Exception as e:
    print('no JSON result, see', out + '.err', e); sys.exit(1)
open(out + '.md', 'w').write(d.get('result', ''))
print('session', d.get('session_id'), 'turns', d.get('num_turns'),
      'cost_usd', round(d.get('total_cost_usd', 0), 2), 'chars', len(d.get('result', '')))
EOF
echo "cwd was $work (empty); result in ${out}.md"
