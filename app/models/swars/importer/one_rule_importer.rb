module Swars
  module Importer
    class OneRuleImporter
      attr_reader :params

      class_attribute :default_options, default: {
        :verbose                => Rails.env.development?,
        :last_page_break        => true,  # 最後のページと思われるときは終わる
        :early_break            => false, # 1ページ目で新しいものが見つからなければ終わる
        :bs_error_capture_block => nil,   # blockが渡されていれば呼ぶ
        :bs_error_capture_fake  => false, # trueならわざと例外
      }

      # Importer::OneRuleImporter.new(user_key: "kinakom0chi", rule_key: :ten_min).run
      def initialize(params = {})
        @params = default_options.merge(params)
      end

      def run
        new_keys.each(&method(:import_process))
      end

      private

      # 対象ルールのすべての(まだDBには取り込んでいない)対局キーたちを集める
      def new_keys
        new_keys = Set.new
        (params[:page_max] || 1).times do |i|
          result = Agent::History.new(params.merge(page_index: i)).fetch
          log_puts { [params[:user_key], "P#{i.next}", rule_info.name, result.inspect].join(" ") }
          new_keys += result.new_keys
          if params[:last_page_break]
            if result.last_page?
              log_puts { "最後のページと思われるので終わる" }
              break
            end
          end
          if params[:early_break]
            if result.new_keys.empty?
              log_puts { "新しい対局が見つからなかったので終わる(次のページはないと考える)" }
              break
            end
          end
        end
        new_keys
      end

      def import_process(key)
        begin
          if params[:bs_error_capture_fake]
            raise Bioshogi::BioshogiError, "(test1)\n(test2)\n"
          end
          BattleImporter.new(params.merge(key: key, skip_if_exist: false)).run
        rescue Bioshogi::BioshogiError => error
          if f = params[:bs_error_capture_block]
            f.call({key: key, error: error})
          else
            raise error
          end
        end
      end

      def rule_info
        @rule_info ||= RuleInfo.fetch(params[:rule_key])
      end

      def log_puts
        if !params[:verbose]
          return
        end
        puts yield
      end
    end
  end
end
