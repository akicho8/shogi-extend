# 将棋ウォーズ棋譜検索対局ページURL
# rails r 'puts KifuExtractor.extract("https://www.shogi-extend.com/swars/battles/htrns-kinakom0chi-20211217_190002/")'
module KifuExtractor
  class CaseShogiExtendSwarsBattleUrl < Extractor
    def resolve
      if uri = extracted_uri
        if uri.path
          if md = uri.path.match(%r{/swars/battles/(?<battle_key>[\w-]+)})
            key = md["battle_key"]
            Swars::Battle.single_battle_import(key: key)
            if battle = Swars::Battle.find_by(key: key)
              @body = battle.kifu_body
            end
          end
        end
      end
    end
  end
end
