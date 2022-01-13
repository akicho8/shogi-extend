# lishogi
# rails r 'puts KifuExtractor.extract("https://lishogi.org/ZY2Tyy2dUdLl")'
# rails r 'puts KifuExtractor.extract("https://lishogi.org/ZY2Tyy2d/sente")'
# rails r 'puts KifuExtractor.extract("https://lishogi.org/ZY2Tyy2d/gote")'
# rails r 'puts KifuExtractor.extract("https://lishogi.org/ZY2Tyy2d")'
module KifuExtractor
  class CaseLishogiBattle < Extractor
    def resolve
      if uri = extracted_uri
        if uri.host.end_with?("lishogi.org") && !uri.path.start_with?("/editor/")
          # https://lishogi.org/game/export/MDFjhiLq?csa=1&clocks=0
          if false
            # 仕様が不安定
            # 55将棋が読めない問題あり
            #
            # NOTE: user_agent が "Faraday v1" や通常のであれば kif を埋めない
            # wget や googlebot であれば kif が埋まっている
            doc = WebAgent.document(extracted_url, user_agent: "Mozilla/5.0 (compatible; Googlebot/2.1; +http://www.google.com/bot.html)")
            if e = doc.at("div[class='kif']")
              @body = e.text
            end
          else
            # "id":"151jxej8"

            key_max = 8
            key = nil

            # sente gote がついたパスは正しいキーになっている
            # "https://lishogi.org/ZY2Tyy2d/sente" -> "ZY2Tyy2d"
            unless key
              if md = uri.path.match(%r{^/(?<key>\w+)/(sente|gote)})
                key = md["key"]
              end
            end

            # 棋譜ダウンロードURLも正しい
            # "https://lishogi.org/game/export/ZY2Tyy2d?csa=1&clocks=0"
            unless key
              if md = uri.path.match(%r{^/game/export/(?<key>\w+)})
                key = md["key"]
              end
            end

            # sente gote がついていないパスのキーは9文字以上ならきっと正しくない
            # 先頭の8文字だけが実際のキー
            # "https://lishogi.org/ZY2Tyy2dUdLl" => "ZY2Tyy2dUdLl" => "ZY2Tyy2d"
            unless key
              if md = uri.path.match(%r{^/(?<key>\w+)})
                key = md["key"].first(key_max)
              end
            end

            if key
              if false
                # CSAとして取得
                # 良い: 揺らぎがない
                # 悪い: 盤面が5五将棋の初期値になってない
                export_url = "https://lishogi.org/game/export/#{key}?csa=1&clocks=0"
                if v = WebAgent.raw_fetch(export_url)
                  if Bioshogi::Parser::CsaParser.accept?(v)
                    v = v.strip # 無駄な改行があるので取る
                    @body = v
                  end
                end
              else
                # KIFとして取得
                # 悪い: 揺らぐかもしれない
                # 悪い: Shift_JIS になっている
                # 悪い: 5五将棋の表記が "五々将棋" となっている
                export_url = "https://lishogi.org/game/export/#{key}?csa=0&clocks=0"
                if v = WebAgent.raw_fetch(export_url)
                  if Bioshogi::Parser::KifParser.accept?(v)
                    v = v.toutf8  # Shift_JIS になっているため
                    v = v.strip   # 無駄な改行があるので取る
                    @body = v
                  end
                end
              end
            end
          end
        end
      end
    end
  end
end
