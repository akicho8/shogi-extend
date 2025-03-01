# Importer::SingleHistoryImporter.new(user_key: "kinakom0chi", rule_key: :ten_min).call

module Swars
  module Importer
    class SingleHistoryImporter < Base
      def self.default_params
        {
          :verbose                => Rails.env.development?,
          :hard_crawl             => false, # true: 新しい対局が見つからなくても次のページに進む(遅いが過去の棋譜を落とせる)
          :last_page_break        => true,  # 最後のページと思われるときは終わる
          :bs_error_capture_block => nil,   # blockが渡されていれば呼ぶ
          :bs_error_capture_fake  => false, # trueならわざと例外
        }
      end

      def default_params
        self.class.default_params
      end

      def call
        new_keys.each(&method(:import_process))
      end

      private

      # 対象ルールのすべての(まだDBには取り込んでいない)対局キーたちを集める
      def new_keys
        new_keys = Set.new
        page_max.times do |i|
          result = Agent::History.new(params.merge(page_index: i)).fetch
          log_puts { [params[:user_key], "P#{i.next}", rule_name, result.inspect].join(" ") }
          new_keys += result.new_keys
          if params[:last_page_break]
            if result.last_page?
              log_puts { "最後のページと思われるので終わる" }
              break
            end
          end
          if page_max > 1
            if !params[:hard_crawl]
              if result.new_keys.empty?
                log_puts { "新しい対局が見つからなかったので終わる(次のページはないと考える)" }
                break
              end
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
          BattleImporter.new(params.merge(key: key)).call
        rescue Bioshogi::BioshogiError => error
          if f = params[:bs_error_capture_block]
            f.call({key: key, error: error})
          else
            raise error
          end
        end
      end

      def rule_name
        if v = params[:rule_key]
          RuleInfo.fetch(v).name
        else
          "ルール未指定"
        end
      end

      def log_puts
        if !params[:verbose]
          return
        end
        puts yield
      end

      def page_max
        params[:page_max] || 1
      end
    end
  end
end
