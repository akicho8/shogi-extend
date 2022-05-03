# 将棋ウォーズ本家対局URL
# rails r 'puts KifuExtractor.extract("https://shogiwars.heroz.jp/games/Kato_Hifumi-SiroChannel-20200927_180900")'
# rails r 'puts KifuExtractor.extract("将棋ウォーズ棋譜 https://shogiwars.heroz.jp/games/Kato_Hifumi-SiroChannel-20200927_180900")'
#
# ・URLが行頭から開始していない場合 url_type? は false になる
# ・なので行頭から開始していない場合のチェックも必要
#
module KifuExtractor
  class CaseUrlHerozSwarsGames < Extractor
    def resolve
      if url_type? || swars_battle_url_match?
        if key = Swars::Battle.battle_key_extract(item.source)
          Swars::Battle.single_battle_import(key: key)
          if battle = Swars::Battle.find_by(key: key)
            @body = battle.kifu_body
          end
        end
      end
    end

    private

    def swars_battle_url_match?
      item.source.lines.count <= 2 && item.source.match?(/将棋ウォーズ棋譜|#shogiwars|#棋神解析/)
    end
  end
end
