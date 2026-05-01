# 棋神アナリティクス
# rails r "puts KifuExtractor.extract('https://kishin-analytics.heroz.jp/?wars_game_id=shogo1225-dododon123-20230528_172207')"
module KifuExtractor
  class CaseUrlKishinAnalytics < Base
    def resolve
      if uri = extracted_uri
        if uri.to_s.include?("kishin-analytics.heroz.jp")
          if uri.query
            hv = Rack::Utils.parse_query(uri.query)
            if key = hv["wars_game_id"]
              key = Swars::BattleKey.create(key)
              Swars::Importer::BattleImporter.new(key: key).call
              if battle = Swars::Battle.find_by(key: key.to_s)
                @body = battle.kifu_body
              end
            end
          end
        end
      end
    end
  end
end
