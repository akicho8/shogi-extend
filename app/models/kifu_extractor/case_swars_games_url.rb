# 将棋ウォーズ本家対局URL
# rails r 'puts KifuExtractor.extract("https://shogiwars.heroz.jp/games/Kato_Hifumi-SiroChannel-20200927_180900")'
module KifuExtractor
  class CaseSwarsGamesUrl < Extractor
    def resolve
      if url_type?
        if key = Swars::Battle.battle_key_extract(item.source)
          Swars::Battle.single_battle_import(key: key)
          if battle = Swars::Battle.find_by(key: key)
            @body = battle.kifu_body
          end
        end
      end
    end
  end
end
