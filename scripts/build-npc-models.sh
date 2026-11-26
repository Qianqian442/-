#!/usr/bin/env bash
set -euo pipefail

# Build realistic, full-body, rigged NPC GLBs from Ara 3D Gen / CC0 MakeHuman assets.
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
WORK="${RUNNER_TEMP:-/tmp}/ara-3d-gen"
OUT="$ROOT/public/npc"
mkdir -p "$OUT"

git clone --depth 1 https://github.com/olatunde85/3d-gen.git "$WORK"
cd "$WORK"
npm install --no-audit --no-fund
npm run setup-assets

# Each export is a complete, textured, full-body GLB with a game skeleton.
npm run export -- --preset "The Security Guard" --detail medium --formats glb --out "$OUT"
npm run export -- --preset "The Schoolgirl" --detail medium --formats glb --out "$OUT"
npm run export -- --preset "The Gamer" --detail medium --formats glb --out "$OUT"
cat > "$WORK/grandmother.json" <<'JSON'
{
  "name": "Grandmother",
  "gender": 0,
  "age": 0.92,
  "muscle": 0.24,
  "weight": 0.56,
  "height": 0.48,
  "asian": 0.82,
  "african": 0.02,
  "caucasian": 0.16,
  "hair": "bob02",
  "hairTint": "#b9b4ad",
  "outfit": "none",
  "top": "silk_blouse",
  "jacket": "overcoat",
  "bottom": "suit_trousers",
  "shoes": "shoes03",
  "expression": "neutral"
}
JSON
npm run export -- --params "$WORK/grandmother.json" --detail medium --formats glb --out "$OUT"

test -s "$OUT/The_Security_Guard.glb"
test -s "$OUT/The_Schoolgirl.glb"
test -s "$OUT/The_Gamer.glb"
test -s "$OUT/Grandmother.glb"
ls -lh "$OUT"/*.glb
