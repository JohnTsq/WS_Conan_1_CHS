import std/[algorithm, re, sequtils, strformat, strutils, tables, unicode]
import freetype

proc getCharsets(textPath: string): TableRef[int, seq[Rune]] =
    result = newTable[int, seq[Rune]]()
    let  indexPattern = re"""[.]loadtable ["]marubatsu_tbl\\marubatsu_chs_(..)[.]tbl["]"""
    let stringPattern = re"""[^;]*?.marubatsu ["](.*?)["]"""

    var index = -1
    var matches: string = ""
    let content: string = readFile(textPath)
    for line in content.splitLines():
        var match: array[1, string]
        if line.match(stringPattern, match):
            doAssert index >= 0
            matches.add(match[0])
        elif line.match(indexPattern, match):
            if index >= 0:
                result[index] = matches.toRunes.deduplicate
                result[index].sort(proc(a, b: Rune): int = cmp(a.int32, b.int32))
            index = parseHeXInt(match[0])
            matches = ""
    result[index] = matches.toRunes.deduplicate
    result[index].sort(proc(a, b: Rune): int = cmp(a.int32, b.int32))

proc glyphBytes(fontPath: string, fontSize: int, chara: string): array[16, byte] =
    var lib: FT_Library
    var face: FT_Face
    if FT_Init_FreeType(lib) != 0:
        quit "Failed to initialize FreeType library"
    if FT_New_Face(lib, fontPath, 0, face) != 0:
        quit "Failed to load font\n" & fontPath
    if FT_Set_Pixel_Sizes(face, 0, fontSize.FT_UInt) != 0:
        quit "Failed to set font size"
    if FT_Load_Char(face, chara.runeAt(0).FT_UInt, FT_LOAD_RENDER or FT_LOAD_TARGET_MONO) != 0:
        quit "Failed to load glyph"
    let bitmap = face.glyph.bitmap
    # if bitmap.rows != 7:
    #     echo chara
        # echo FT_Pixel_Mode(bitmap.pixel_mode)
        # echo &"{bitmap.pitch = }"
        # echo &"{bitmap.rows = }"

    # result = newSeq[byte]((8 - bitmap.rows.int) * 2)
    # for row in 0 ..< bitmap.rows:
    #     result.add bitmap.buffer[row * bitmap.pitch.uint32].byte
    #     result.add bitmap.buffer[row * bitmap.pitch.uint32].byte

    # for row in 0 ..< bitmap.rows:
    #     result[(8 - bitmap.rows + row)*2] = bitmap.buffer[row * bitmap.pitch.uint32].byte
    #     result[(8 - bitmap.rows + row)*2 + 1] = bitmap.buffer[row * bitmap.pitch.uint32].byte
    var val: int
    for row in 0 ..< bitmap.rows:
        for bit in 0 .. 7:
            val = (bitmap.buffer[row * bitmap.pitch.uint32].int shr bit) and 1
            result[(7 - bit) * 2] = result[(7 - bit) * 2] or (val shl ((8 - bitmap.rows) + row)).byte
            result[(7 - bit) * 2 + 1] = result[(7 - bit) * 2]
    
    if chara.runeAt(0) == "一".runeAt(0):
        result = [0x10.byte, 0x10.byte,
                  0x10.byte, 0x10.byte,
                  0x10.byte, 0x10.byte,
                  0x10.byte, 0x10.byte,
                  0x10.byte, 0x10.byte,
                  0x10.byte, 0x10.byte,
                  0x10.byte, 0x10.byte,
                     0.byte,    0.byte]
    elif chara.runeAt(0) == "口".runeAt(0):
        result = [0x7C.byte, 0x7C.byte,
                  0x44.byte, 0x44.byte,
                  0x44.byte, 0x44.byte,
                  0x44.byte, 0x44.byte,
                  0x44.byte, 0x44.byte,
                  0x7C.byte, 0x7C.byte,
                     0.byte,    0.byte,
                     0.byte,    0.byte]

    discard FT_Done_Face(face)
    discard FT_Done_FreeType(lib)

proc generate_marubatsu_tbl(sortedCharset: seq[Rune], tblIndex: int, startCodepoint = 0x60) =
    assert (startCodepoint in 0x60 .. 0xAA) or (startCodepoint in 0x10 .. 0x5A)
    let marubatsuTbl = open(&"marubatsu_tbl\\marubatsu_chs_{tblIndex:02X}.tbl", fmWrite)
    for unicode in 0xFF10 .. 0xFF19:
        marubatsuTbl.writeLine &"{unicode - 0xFF10:02X}={Rune(unicode)}"
    marubatsuTbl.writeLine "5F=　"
    for idx in 0 ..< sortedCharset.len:
        marubatsuTbl.writeLine &"{startCodepoint + idx:02X}={sortedCharset[idx]}"

proc main(marubatsuPath, fontPath: string, fontSize: int) =
    let charsets: TableRef[int, seq[Rune]] = getCharsets(marubatsuPath)
    let marubatsuAsm = open(r"graphic\marubatsu_font.asm", fmWrite)
    var fontBytes: seq[byte]
    var filteredCharset: seq[Rune]
    for key in charsets.keys.toSeq.sorted:
        echo key, ": ", charsets[key]
        filteredCharset = charsets[key].filterIt(it notin "０１２３４５６７８９　".toRunes)

        fontBytes = @[]
        for chara in filteredCharset:
            fontBytes.add glyphBytes(fontPath, fontSize, $chara)
        writeFile(fmt"graphic\marubatsu_font\marubatsu_{key:02X}.bin", fontBytes)

        writeLine(marubatsuAsm, &"; {filteredCharset}")
        writeLine(marubatsuAsm, &".orga 0x{0x04_0000 + 0x0400 + 0x0800 * key:06X}")
        writeLine(marubatsuAsm, &"\t.incbin \"graphic\\marubatsu_font\\marubatsu_{key:02X}.bin\"")
        writeLine(marubatsuAsm, "")

        generate_marubatsu_tbl(filteredCharset, key)
    close(marubatsuAsm)

when isMainModule:
    let marubatsuPath: string = "strings\\string_marubatsu.asm"
    let fontPath: string = "resources\\ChillBitmap7x.ttf"
    let fontSize: int = 8
    main(marubatsuPath, fontPath, fontSize)