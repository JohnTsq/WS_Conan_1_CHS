import re
from pathlib import Path
from typing import Iterator, Tuple

strings_folder: Path = Path("strings")
origin: Path = strings_folder / "baserom"
translation: Path = strings_folder / "translated"

match_pattern = r'[^;]*?[.]strn ".*?"'
match_pattern = re.compile(match_pattern)
for f in origin.glob("*.asm"):
    with open(f, "r", encoding="utf-8") as f1, \
         open(translation / f.name.replace('0x0', '0x1'), "r", encoding="utf-8") as f2, \
         open(strings_folder / f.name, "w", encoding="utf-8") as f3:
        for line1, line2 in zip(f1, f2):
            if match_pattern.match(line1.strip('\n')):
                f3.write(line2)
            else:
                f3.write(line1)