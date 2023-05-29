# 棋神アナリティクス
# rails r "puts KifuExtractor.extract('https://kishin-analytics.heroz.jp/?wars_game_id=shogo1225-dododon123-20230528_172207')"
module KifuExtractor
  class CaseUrlKishinAnalytics < Base
    def resolve
      if uri = extracted_uri
        if uri.host.include?("kishin-analytics.heroz.jp")
          if v = uri_fetched_content
            # "shogi_wars": {...} のデータを取り出す
            if md = v.match(/"shogi_wars":\s*(?<json_str>{.*?})/)
              json_params = JSON.parse(md["json_str"], symbolize_names: true)
              #
              # p json_params
              # {
              #   :game_id => "shogo1225-dododon123-20230528_172207",
              #   :kif     => "開始日時：2023/05/28 17:22:07\r\n終了日時：2023/05/28 17:27:56\r\n場所：将棋ウォーズ\r\n手合割：平手\r\n先手：shogo1225\r\n後手：dododon123\r\n1 ７六歩(77)\r\n2 ３四歩(33)\r\n3 ６六歩(67)\r\n4 ３二飛(82)\r\n5 ６八飛(28)\r\n6 ７二銀(71)\r\n7 ４八玉(59)\r\n8 ６二玉(51)\r\n9 ３八玉(48)\r\n10 ７一玉(62)\r\n11 ４八金(49)\r\n12 ３五歩(34)\r\n13 ７八銀(79)\r\n14 ３六歩(35)\r\n15 ３六歩(37)\r\n16 ３六飛(32)\r\n17 ３七歩打\r\n18 ３四飛(36)\r\n19 ２八銀(39)\r\n20 ４二銀(31)\r\n21 ６七銀(78)\r\n22 １四歩(13)\r\n23 １六歩(17)\r\n24 １三角(22)\r\n25 ７七角(88)\r\n26 ３三桂(21)\r\n27 ５八金(69)\r\n28 ５二金(41)\r\n29 ５六銀(67)\r\n30 ４四歩(43)\r\n31 ６五歩(66)\r\n32 ４五歩(44)\r\n33 ５五銀(56)\r\n34 ４三銀(42)\r\n35 ６四歩(65)\r\n36 ６四歩(63)\r\n37 ６四銀(55)\r\n38 ６三歩打\r\n39 ５五銀(64)\r\n40 ５四歩(53)\r\n41 ６六銀(55)\r\n42 ８二玉(71)\r\n43 ９六歩(97)\r\n44 ５五歩(54)\r\n45 ５五銀(66)\r\n46 ５六歩打\r\n47 ６九飛(68)\r\n48 ５七歩成(56)\r\n49 ５七金(58)\r\n50 ５六歩打\r\n51 ５八金(57)\r\n52 ２四角(13)\r\n53 ６四歩打\r\n54 ６四歩(63)\r\n55 ３六歩(37)\r\n56 ５四銀(43)\r\n57 ６四銀(55)\r\n58 ６三金(52)\r\n59 ６三銀(64)\r\n60 ６三銀(54)\r\n61 ４四金打\r\n62 ５七銀打\r\n63 ３四金(44)\r\n64 ４八銀成(57)\r\n65 ４八金(58)\r\n66 ５七歩成(56)\r\n67 ２四金(34)\r\n68 ４八と(57)\r\n69 ４八玉(38)\r\n70 ２四歩(23)\r\n71 ３二飛打\r\n72 ４六歩(45)\r\n73 ６三飛成(69)\r\n74 ５六金打\r\n75 ３七玉(48)\r\n76 ４七歩成(46)\r\n77 ２六玉(37)\r\n78 ２五金打\r\n79 １七玉(26)\r\n80 ３八と(47)\r\n81 ３三角成(77)\r\n82 １五歩(14)\r\n83 ７二飛成(32)\r\n84 ７二金(61)\r\n85 ７二龍(63)\r\n86 ７二玉(82)\r\n87 ４五角打\r\n88 ６三歩打\r\n89 ７一金打\r\n90 ８二玉(72)\r\n91 ７四桂打\r\n92 ９二玉(82)\r\n93 ５六角(45)\r\n94 １六歩(15)\r\n95 投了",
              # }
              #
              @body = json_params.fetch(:kif)
            end
          end
        end
      end
    end
  end
end
