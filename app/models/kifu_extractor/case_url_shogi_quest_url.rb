# rails r 'puts KifuExtractor.extract("https://kifu.questgames.net/shogi/games/0yxu6r0shvfy")'

module KifuExtractor
  class CaseUrlShogiQuestUrl < Base
    def resolve
      if uri = extracted_uri
        if uri.to_s.include?("kifu.questgames.net/shogi/games/")
          if v = uri_fetched_content
            if md = v.match(/position={moves:(\[.*?\])/)
              s = md.captures.first
              # ここで
              # [{t:1,m:"7776FU"},{t:2850,m:"4132KI"},{t:400,s:"LOSE:TIMEUP"}]
              # のような形式が取れるのだが
              # 一部で {t:2850,m:c} などと alias が入っていたりするので無理
            end
          end
        end
      end
    end
  end
end
