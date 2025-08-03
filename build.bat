@REM ".venv/Scripts/python.exe" "tool/generate_font.py"
nim c tool\generate_font_and_tbl.nim
tool\generate_font_and_tbl.exe
nim c tool\generate_marubatsu_font_and_tbl.nim
tool\generate_marubatsu_font_and_tbl.exe
tool\armips\armips.exe main.asm -sym main.sym