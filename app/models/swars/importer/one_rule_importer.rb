module Swars
  module Importer
    class OneRuleImporter
      attr_reader :params

      # Importer::OneRuleImporter.new(user_key: "kinakom0chi", rule_key: :ten_min).run
      def initialize(params = {})
        @params = {
          :verbose            => Rails.env.development?,
          :last_page_break    => true,  # 最後のページと思われるときは終わる
          :early_break        => false, # 1ページ目で新しいものが見つからなければ終わる
          :error_capture      => nil,   # blockが渡されていれば呼ぶ
          :error_capture_fake => false, # trueならわざと例外
        }.merge(params)
      end

      def run
        if params[:SwarsFormatIncompatible]
          raise Agent::SwarsFormatIncompatible
        end
        keys = all_battle_keys_collect      # 履歴ページから対局URLを収集する
        keys = exist_key_reject(keys)       # すでに取り込んであるものは除外する
        keys.each(&method(:import_process)) # 新しいものだけ取り込む
      end

      private

      # 対象ルールのすべての対局キーを取得する
      def all_battle_keys_collect
        keys = []
        (params[:page_max] || 1).times do |i|
          result = Agent::Index.new(params.merge(page_index: i)).fetch
          if params[:verbose]
            puts "[#{params[:user_key]}][P#{i.next}][#{rule_info.name}][#{result.keys.size}件][#{result.last_page? ? '最後' : '続く'}]"
          end
          keys += result.keys
          # 最後のページと思われる場合は終わる
          if params[:last_page_break]
            if result.last_page?
              if params[:verbose]
                puts "[P#{i.next}] 最後のページだった --> break"
              end
              break
            end
          end
          # 新しいものがなければ終わる (次のページもないと想定する)
          if params[:early_break]
            new_keys = result.keys - Battle.where(key: result.keys).pluck(:key)
            if new_keys.empty?
              if params[:verbose]
                puts "[P#{i.next}] 新しいレコードがなかった --> break"
              end
              break
            end
          end
        end
        keys
      end

      # 既存のキーは除外する
      def exist_key_reject(keys)
        if params[:error_capture_fake]
          return keys
        end
        keys - Battle.where(key: keys).pluck(:key)
      end

      def import_process(key)
        begin
          if params[:error_capture_fake]
            raise Bioshogi::BioshogiError, "(test1)\n(test2)\n"
          end
          BattleImporter.new(params.merge(key: key, skip_if_exist: false)).run
        rescue Bioshogi::BioshogiError => error
          if f = params[:error_capture]
            f.call({key: key, error: error})
          else
            raise error
          end
        end
      end

      def rule_info
        @rule_info ||= RuleInfo.fetch(params[:rule_key])
      end
    end
  end
end
