# rails r 'puts KifuExtractor.extract("https://kifu.questgames.net/shogi/games/h22krtg0jpv8")'
#
# 見える (200)
# https://kifu.questgames.net/shogi/games/h22krtg0jpv8
#
# 見えない (404)
# https://kifu.questgames.net/shogi10/games/svkf1yqr8uwz
# https://kifu.questgames.net/shogi2/games/dkzw4utbxtg3
#
# エラー (500)
# https://kifu.questgames.net/shogi/games/0yxu6r0shvfy
#
module KifuExtractor
  class CaseUrlShogiQuestUrl < Base
    def resolve
      if uri = extracted_uri
        if uri.to_s.match?(%r{kifu.questgames.net/shogi.*/games/\w+})
          if v = uri_fetched_content
            if v = csa_body
              @body = v
            end
          end
        end
      end
    end

    def csa_body
      if v = uri_fetched_content
        if md = v.match(%r{<script>window.__NUXT__=(.*?)</script>})
          js_code = md.captures.first                               # この状態ではデータの一部が共通化されていて読み取れないので
          Rails.logger.debug(js_code)
          print_code = %(console.log(JSON.stringify(#{js_code})))   # 実行して inspect する

          path = Tempfile.create(["", ".js"], &:path)
          file = Pathname(path)
          print_code.force_encoding("UTF-8")
          file.write(print_code)
          json_str = `node #{file}`
          file.delete

          hash = JSON.parse(json_str)               # JSON化できたが、キーがマジックナンバーのため辿ることができない。そこで values としている。
          Rails.logger.debug(hash)
          if data = hash["data"].presence
            hash = data.values.first                # => {"id" => "h22krtg0jpv8", "gtype" => "shogi10", "position" => {"moves" => [{"m" => "7776FU", "t" => 383}, {"m" => "3334FU", "t" => 1492}, {"m" => "6766FU", "t" => 1462}, {"m" => "8384FU", "t" => 1237}, {"m" => "8877KA", "t" => 1594}, {"m" => "7162GI", "t" => 1439}, {"m" => "2868HI", "t" => 3768}, {"m" => "5354FU", "t" => 2017}, {"m" => "7978GI", "t" => 2342}, {"m" => "8485FU", "t" => 1512}, {"m" => "7867GI", "t" => 1127}, {"m" => "5142OU", "t" => 3695}, {"m" => "6888HI", "t" => 2202}, {"m" => "4232OU", "t" => 2606}, {"m" => "6756GI", "t" => 3199}, {"m" => "4344FU", "t" => 10912}, {"m" => "5665GI", "t" => 6986}, {"m" => "6253GI", "t" => 2958}, {"m" => "5948OU", "t" => 4459}, {"m" => "5455FU", "t" => 31315}, {"m" => "7675FU", "t" => 11515}, {"m" => "6364FU", "t" => 9962}, {"m" => "6576GI", "t" => 1665}, {"m" => "5354GI", "t" => 4977}, {"m" => "6958KI", "t" => 11214}, {"m" => "3142GI", "t" => 2114}, {"m" => "4838OU", "t" => 4378}, {"m" => "4253GI", "t" => 3798}, {"m" => "1716FU", "t" => 5913}, {"m" => "1314FU", "t" => 1981}, {"m" => "3828OU", "t" => 1620}, {"m" => "6152KI", "t" => 12889}, {"m" => "3938GI", "t" => 1641}, {"m" => "4445FU", "t" => 9254}, {"m" => "9796FU", "t" => 5879}, {"m" => "5243KI", "t" => 28724}, {"m" => "8997KE", "t" => 14428}, {"m" => "2244KA", "t" => 14980}, {"m" => "9785KE", "t" => 4276}, {"m" => "3233OU", "t" => 7385}, {"m" => "8573NK", "t" => 9165}, {"m" => "8173KE", "t" => 2915}, {"m" => "7574FU", "t" => 1925}, {"m" => "7385KE", "t" => 3674}, {"m" => "7795KA", "t" => 5427}, {"m" => "9394FU", "t" => 6243}, {"m" => "9559KA", "t" => 15078}, {"m" => "5556FU", "t" => 38556}, {"m" => "7667GI", "t" => 8949}, {"m" => "5657TO", "t" => 10174}, {"m" => "5857KI", "t" => 1601}, {"m" => "1415FU", "t" => 36138}, {"m" => "7473TO", "t" => 9312}, {"m" => "8222HI", "t" => 8307}, {"m" => "8786FU", "t" => 3989}, {"m" => "1516FU", "t" => 2800}, {"m" => "0018FU", "t" => 3477}, {"m" => "6465FU", "t" => 5787}, {"m" => "8685FU", "t" => 6891}, {"m" => "6566FU", "t" => 1355}, {"m" => "6766GI", "t" => 6629}, {"m" => "0065FU", "t" => 1664}, {"m" => "6677GI", "t" => 3064}, {"m" => "0076FU", "t" => 1862}, {"m" => "8887HI", "t" => 14890}, {"m" => "7677TO", "t" => 4932}, {"m" => "5977KA", "t" => 1436}, {"m" => "0066GI", "t" => 9916}, {"m" => "7766KA", "t" => 7227}, {"m" => "6566FU", "t" => 2156}, {"m" => "0055FU", "t" => 18094}, {"m" => "4455KA", "t" => 4662}, {"m" => "0056FU", "t" => 5618}, {"m" => "0036KE", "t" => 2550}, {"s" => "LOSE:RESIGN", "t" => 4274}]}, "tcb" => 600000, "attrs" => ["opp:human", "opp:weak", "senkei:shiken", "kakoi:mino", "opp:strong", "senkei:ibisha", "senkei:taifuri"], "players" => [{"id" => "tenshinohige", "name" => "TenshiNoHige", "oldR" => 1490.485, "newR" => 1483.96, "oldD" => -2, "newD" => -2}, {"id" => "berusehica", "name" => "berusehica", "oldR" => 1464.996, "newR" => 1471.349, "oldD" => 0, "newD" => 0, "avatar" => "t_01"}], "created" => "2025-03-18T18:17:13.535Z", "finished" => true}
            created = hash["created"].to_time       # => 2025-03-19 03:17:13.535 +0900
            moves = hash["position"]["moves"]       # => [{"m" => "7776FU", "t" => 383}, {"m" => "3334FU", "t" => 1492}, {"m" => "6766FU", "t" => 1462}, {"m" => "8384FU", "t" => 1237}, {"m" => "8877KA", "t" => 1594}, {"m" => "7162GI", "t" => 1439}, {"m" => "2868HI", "t" => 3768}, {"m" => "5354FU", "t" => 2017}, {"m" => "7978GI", "t" => 2342}, {"m" => "8485FU", "t" => 1512}, {"m" => "7867GI", "t" => 1127}, {"m" => "5142OU", "t" => 3695}, {"m" => "6888HI", "t" => 2202}, {"m" => "4232OU", "t" => 2606}, {"m" => "6756GI", "t" => 3199}, {"m" => "4344FU", "t" => 10912}, {"m" => "5665GI", "t" => 6986}, {"m" => "6253GI", "t" => 2958}, {"m" => "5948OU", "t" => 4459}, {"m" => "5455FU", "t" => 31315}, {"m" => "7675FU", "t" => 11515}, {"m" => "6364FU", "t" => 9962}, {"m" => "6576GI", "t" => 1665}, {"m" => "5354GI", "t" => 4977}, {"m" => "6958KI", "t" => 11214}, {"m" => "3142GI", "t" => 2114}, {"m" => "4838OU", "t" => 4378}, {"m" => "4253GI", "t" => 3798}, {"m" => "1716FU", "t" => 5913}, {"m" => "1314FU", "t" => 1981}, {"m" => "3828OU", "t" => 1620}, {"m" => "6152KI", "t" => 12889}, {"m" => "3938GI", "t" => 1641}, {"m" => "4445FU", "t" => 9254}, {"m" => "9796FU", "t" => 5879}, {"m" => "5243KI", "t" => 28724}, {"m" => "8997KE", "t" => 14428}, {"m" => "2244KA", "t" => 14980}, {"m" => "9785KE", "t" => 4276}, {"m" => "3233OU", "t" => 7385}, {"m" => "8573NK", "t" => 9165}, {"m" => "8173KE", "t" => 2915}, {"m" => "7574FU", "t" => 1925}, {"m" => "7385KE", "t" => 3674}, {"m" => "7795KA", "t" => 5427}, {"m" => "9394FU", "t" => 6243}, {"m" => "9559KA", "t" => 15078}, {"m" => "5556FU", "t" => 38556}, {"m" => "7667GI", "t" => 8949}, {"m" => "5657TO", "t" => 10174}, {"m" => "5857KI", "t" => 1601}, {"m" => "1415FU", "t" => 36138}, {"m" => "7473TO", "t" => 9312}, {"m" => "8222HI", "t" => 8307}, {"m" => "8786FU", "t" => 3989}, {"m" => "1516FU", "t" => 2800}, {"m" => "0018FU", "t" => 3477}, {"m" => "6465FU", "t" => 5787}, {"m" => "8685FU", "t" => 6891}, {"m" => "6566FU", "t" => 1355}, {"m" => "6766GI", "t" => 6629}, {"m" => "0065FU", "t" => 1664}, {"m" => "6677GI", "t" => 3064}, {"m" => "0076FU", "t" => 1862}, {"m" => "8887HI", "t" => 14890}, {"m" => "7677TO", "t" => 4932}, {"m" => "5977KA", "t" => 1436}, {"m" => "0066GI", "t" => 9916}, {"m" => "7766KA", "t" => 7227}, {"m" => "6566FU", "t" => 2156}, {"m" => "0055FU", "t" => 18094}, {"m" => "4455KA", "t" => 4662}, {"m" => "0056FU", "t" => 5618}, {"m" => "0036KE", "t" => 2550}, {"s" => "LOSE:RESIGN", "t" => 4274}]

            ShogiQuestToStandardCsa.new(moves: moves, created: created, user_names: user_names).call
          end
        end
      end
    end

    def user_names
      if v = uri_fetched_content
        if md = v.match(%r{<title>.*?(\S+) vs (\S+)</title>})
          md.captures.to_a        # => ["TenshiNoHige(R1490)", "berusehica(R1464)"]
        end
      end
    end
  end
end
