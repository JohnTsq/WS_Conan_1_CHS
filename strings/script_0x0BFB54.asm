.orga (0x0BC462 + ROM_EXPANSION_OFFSET)
.area (0x0BC6AE + ROM_EXPANSION_OFFSET)-.,0xFF

.align 2,0xFF :: String0x0BC462:
; .strn "オレは高校生探偵　工藤新一{line}ちょっとは知られた　名探偵だ{line}{page}"
  .strn "我是工藤新一{line}是小有名气的高中生侦探{line}{page}"

.align 2,0xFF :: String0x0BC49E:
; .strn "ある日　幼なじみで同級生の蘭と{line}遊園地に遊びに行ったオレは{line}{page}"
  .strn "某一天跟青梅竹马的同学毛利兰{line}到游乐园玩的时候{line}{page}"

.align 2,0xFF :: String0x0BC4DC:
; .strn "黒ずくめの男の　怪しげな{line}取り引き現場を　目撃した{line}{page}"
  .strn "不经意间目击到了{line}黑衣人的交易{line}{page}"

.align 2,0xFF :: String0x0BC512:
; .strn "夢中になっていたオレは　背後に{line}近づく男の仲間に　気づかなかった{line}{page}"
  .strn "因为看得太专心，竟然没有发现{line}他的同伙就在我身后{line}{page}"

.align 2,0xFF :: String0x0BC556:
; .strn "男たちに飲まされた毒薬で　オレは{line}死体も残さずに死ぬ…はずだった{line}{page}"
  .strn "我被那个男人强行灌下毒药{line}就在我以为必死无疑的时候{line}{page}"

.align 2,0xFF :: String0x0BC59A:
; .strn "ところが意識を取りもどしたオレが{line}警官の声に気づき　目を覚ますと…{line}{page}"
  .strn "回复意识的我在警察的呼喊声中醒来{line}睁开眼睛一看…{line}{page}"

.align 2,0xFF :: String0x0BC5E0:
; .strn "体が縮んでしまっていた！{line}{page}"
  .strn "我的身体竟然缩小了！{line}{page}"

.align 2,0xFF :: String0x0BC5FC:
; .strn "工藤新一が生きているとばれれば{line}周りの人間にも危害がおよぶ{line}{page}"
  .strn "如果让那些人知道工藤新一还活着{line}恐怕会害了周围的人{line}{page}"

.align 2,0xFF :: String0x0BC63A:
; .strn "やつらの組織を追うために{line}オレは江戸川コナンと名のり{line}{page}"
  .strn "为了得到有关组织的情报{line}我化名江户川柯南{line}{page}"

.align 2,0xFF :: String0x0BC672:
; .strn "毛利探偵事務所に転がりこんで{line}難事件に立ち向かっている…{line}{page}"
  .strn "寄住在毛利侦探事务所，{line}向各种难解案件发起挑战…{line}{page}"

.endarea

.orga (0x0BFB5D + ROM_EXPANSION_OFFSET) :: .d16 (String0x0BC462 & 0xFFFF)
.orga (0x0BFB63 + ROM_EXPANSION_OFFSET) :: .d16 (String0x0BC49E & 0xFFFF)
.orga (0x0BFB6F + ROM_EXPANSION_OFFSET) :: .d16 (String0x0BC4DC & 0xFFFF)
.orga (0x0BFB75 + ROM_EXPANSION_OFFSET) :: .d16 (String0x0BC512 & 0xFFFF)
.orga (0x0BFB87 + ROM_EXPANSION_OFFSET) :: .d16 (String0x0BC556 & 0xFFFF)
.orga (0x0BFB8D + ROM_EXPANSION_OFFSET) :: .d16 (String0x0BC59A & 0xFFFF)
.orga (0x0BFB99 + ROM_EXPANSION_OFFSET) :: .d16 (String0x0BC5E0 & 0xFFFF)
.orga (0x0BFB9F + ROM_EXPANSION_OFFSET) :: .d16 (String0x0BC5FC & 0xFFFF)
.orga (0x0BFBAB + ROM_EXPANSION_OFFSET) :: .d16 (String0x0BC63A & 0xFFFF)
.orga (0x0BFBB1 + ROM_EXPANSION_OFFSET) :: .d16 (String0x0BC672 & 0xFFFF)
