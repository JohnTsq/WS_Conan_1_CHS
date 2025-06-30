import strutils, re, sets, prelude, sequtils, unicode, freetype, strformat, algorithm, std/[paths, private/osdirs]

proc tblToSeq(tblPath: string): seq[string] =
    var tbl: seq[string] = @[]
    let content = readFile("main_jpn.tbl").strip()
    for line in content.splitLines():
        let parts = line.split("=", maxsplit=1)
        if parts[1].startsWith("{") and parts[1].endsWith("}"):
            discard
        else:
            tbl.add(parts[1])
    return tbl

proc getUniqueCharset(textPath: string): seq[Rune] =
    let matchPattern = re"""[^;]*?.strn ["](.*?)["]"""
    let   subPattern = re"\{.*?\}"

    var matches = ""
    let content = readFile(textPath)
    for line in content.splitLines():
        var match: array[1, string]
        if line.match(matchPattern, match):
            let cleaned = match[0].replace(subPattern, "")
            matches.add(cleaned)
    result = matches.toRunes.deduplicate
    # echo typeof(result)
    # echo result

proc glyphBytes(fontPath: string, fontSize: int, chara: string): seq[byte] =
    var lib: FT_Library
    var face: FT_Face
    if FT_Init_FreeType(lib) != 0:
        quit "Failed to initialize FreeType library"
    if FT_New_Face(lib, fontPath, 0, face) != 0:
        quit "Failed to load font\n" & fontPath
    if FT_Set_Pixel_Sizes(face, 0, fontSize.FT_UInt) != 0:
        quit "Failed to set font size"
    if FT_Load_Char(face, chara.runeAt(0).FT_UInt, FT_LOAD_RENDER) != 0:
        quit "Failed to load char glyph"
    let bitmap = face.glyph.bitmap

    result = @[byte 0, 0]
    for row in 0 ..< (bitmap.rows.int - 1):
        result.add(bitmap.buffer[row * bitmap.pitch].byte)
        if bitmap.pitch == 2:
            result.add(bitmap.buffer[row * bitmap.pitch + 1].byte)
        elif bitmap.pitch == 1:
            result.add(0)
        else:
            quit(fmt"{chara = }\n{bitmap.pitch = }\n{bitmap.width = }\n{bitmap.rows = }")
    discard FT_Done_Face(face)
    discard FT_Done_FreeType(lib)
    # echo chara, result.len

proc main(fontPath: string, fontSize: int, stringsFolder: Path, fontBinFolder: Path) =
    let jpnTbl = tblToSeq("main_jpn.tbl")
    # echo jpnTbl
    var charset: seq[Rune]
    for file in walkFiles("strings/*.asm"):
        charset.add getUniqueCharset(file)
    charset = deduplicate(charset)
    charset.sort(proc(a, b: Rune): int = cmp(a.int32, b.int32))
    # echo charset

    var chsTbl = @jpnTbl
    var fontAsm = open(r"graphic\font.asm", fmWrite)

    for chara in charset:
        if $chara notin chsTbl:
            chsTbl.add $chara
        elif chara.int32 in 0x4E00 .. 0x9FFF:
            var codepoint = chsTbl.find($chara)
            writeLine(fontAsm, &".orga 0x{24*codepoint:06X}")
            writeLine(fontAsm, &"\t.incbin \"graphic\\font\\{codepoint and 0xFF:02X}{codepoint shr 8:02X}.bin\"")
            writeLine(fontAsm, "")
            writeFile(
                fmt"graphic\font\{codepoint and 0xFF:02X}{codepoint shr 8:02X}.bin", 
                glyphBytes(fontPath, fontSize, $chara)
            )
    
    let appendStart = jpnTbl.len
    let appendEnd = chsTbl.high
    writeLine(fontAsm, &".orga 0x{24*append_start:06X}")
    writeLine(
        fontAsm, 
        &"\t.incbin \"graphic\\font\\{appendStart and 0xFF:02X}{appendStart shr 8:02X}-{appendEnd and 0xFF:02X}{appendEnd shr 8:02X}.bin\""
    )
    close(fontAsm)

    var fontBytes: seq[byte]
    for chara in chsTbl[appendStart .. ^1]:
        fontBytes.add glyphBytes(fontPath, fontSize, $chara)
    writeFile(
        fmt"graphic\font\{appendStart and 0xFF:02X}{appendStart shr 8:02X}-{appendEnd and 0xFF:02X}{appendEnd shr 8:02X}.bin", 
        fontBytes
    )

    var mainChsTbl = open("main_chs.tbl", fmWrite)
    for i, chara in chsTbl:
        writeLine(mainChsTbl, &"{i and 0xFF:02X}{i shr 8:02X}={chara}")
    writeLine(mainChsTbl, "FEFF={line}")
    writeLine(mainChsTbl, "FFFF={page}")


when isMainModule:
    let fontPath = r"resources\Small SimSun.ttf"
    let fontSize = 12
    let stringsFolder = Path("strings")
    let fontBinFolder = Path("graphic") / Path("font")
    main(fontPath, fontSize, stringsFolder, fontBinFolder)