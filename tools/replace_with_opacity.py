import re
import sys
from pathlib import Path

root = Path('lib')
pattern = re.compile(r"\.withOpacity\(\s*([0-9]*\.?[0-9]+)\s*\)")
updated_files = []
for p in root.rglob('*.dart'):
    text = p.read_text(encoding='utf-8')
    new = pattern.sub(lambda m: f".withAlpha(({m.group(1)} * 255).round())", text)
    if new != text:
        p.write_text(new, encoding='utf-8')
        updated_files.append(str(p))

print('UPDATED_COUNT:', len(updated_files))
for f in updated_files:
    print(f)
