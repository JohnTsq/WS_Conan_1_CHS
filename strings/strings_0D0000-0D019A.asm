.orga (0x0D0000 + ROM_EXPANSION_OFFSET)
.area (0x0D003E + ROM_EXPANSION_OFFSET)-.,0xFF

String0x0D0000:
; .strn "／まだまだ　情報が{line}たりないな…もっと{line}なにか　あるはず…{line}{page}"
  .strn "／情报还完全不够　{line}应该还有一点的吧…{line}　　　　　　　　　{line}{page}"

.endarea


.orga (0x0D003E + ROM_EXPANSION_OFFSET)
.area (0x0D0078 + ROM_EXPANSION_OFFSET)-.,0xFF

String0x0D003E:
; .strn "だんだん　見えてきた{line}ぞ！　もう少し　捜査{line}を続けよう{line}{page}"
  .strn "一点点能看到谜底了！{line}再继续加把劲　　　　{line}搜查一下吧{line}{page}"

.endarea


.orga (0x0D0078 + ROM_EXPANSION_OFFSET)
.area (0x0D00B8 + ROM_EXPANSION_OFFSET)-.,0xFF

String0x0D0078:
; .strn "もう少しで　すベての{line}なぞが　とけるな…{line}あと　ひといきだ！{line}{page}"
  .strn "差一点就能解开　　　{line}所有的谜题了…　　{line}还差一口气！　　　{line}{page}"

.endarea


.orga (0x0D00B8 + ROM_EXPANSION_OFFSET)
.area (0x0D00E6 + ROM_EXPANSION_OFFSET)-.,0xFF

String0x0D00B8:
; .strn "（カーソル４つ押しで{line}全問正解にできます）{line}{page}"
  .strn "（通过按下４个光标　{line}　来全部正确回答吧）{line}{page}"

.endarea


.orga (0x0D00E6 + ROM_EXPANSION_OFFSET)
.area (0x0D00FA + ROM_EXPANSION_OFFSET)-.,0xFF

String0x0D00E6:
; .strn "　　－問題選択－{line}{page}"
  .strn "　　－问题选择－{line}{page}"

.endarea


.orga (0x0D00FA + ROM_EXPANSION_OFFSET)
.area (0x0D011E + ROM_EXPANSION_OFFSET)-.,0xFF

String0x0D00FA:
; .strn "難易度：{line}べストタイム{line}サイズ：{line}{page}"
  .strn "难易度：{line}最快时间　　{line}大小：　{line}{page}"

.endarea


.orga (0x0D011E + ROM_EXPANSION_OFFSET)
.area (0x0D0136 + ROM_EXPANSION_OFFSET)-.,0xFF

String0x0D011E:
; .strn "　★大小未解決解決！{line}{page}"
  .strn "　★大小未解决解决！{line}{page}"

.endarea


.orga (0x0D0136 + ROM_EXPANSION_OFFSET)
.area (0x0D014E + ROM_EXPANSION_OFFSET)-.,0xFF

String0x0D0136:
; .strn "０１２３４５６７８９{line}{page}"
  .strn "０１２３４５６７８９{line}{page}"

.endarea


.orga (0x0D014E + ROM_EXPANSION_OFFSET)
.area (0x0D019A + ROM_EXPANSION_OFFSET)-.,0xFF

String0x0D014E:
; .strn "途中経過を{line}セーブします{line}{page}"
  .strn "保存已经　{line}游玩的进度　{line}{page}"

String0x0D016A:
; .strn "これがキミの評価だ！{line}タイム　：{line}ミス回数：{line}{page}"
  .strn "这是你游玩的评价！　{line}时　　间：{line}失误次数：{line}{page}"

.endarea

