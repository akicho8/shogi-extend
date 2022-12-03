# 将棋ウォーズ棋譜検索対局ページURL
# rails r 'puts KifuExtractor.extract("https://www.shogi-extend.com/swars/battles/htrns-kinakom0chi-20211217_190002/")'
module KifuExtractor
  class CaseUrlShogiExtendSwarsBattle < Extractor
    def resolve
      if uri = extracted_uri
        if uri.path
          if md = uri.path.match(%r{/swars/battles/(?<battle_key>[\w-]+)})
            key = Swars::BattleKey.create(md["battle_key"])
            Swars::Importer::BattleImporter.new(key: key).run
            if battle = Swars::Battle.find_by(key: key.to_s)
              @body = battle.kifu_body
            end
          end
        end
      end
    end
  end
end
