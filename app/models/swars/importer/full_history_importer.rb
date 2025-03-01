# FullHistoryImporter.new(user_key: "alice", look_up_to_page_x: 3).call
# ~/src/shogi-extend/workbench/swars/full_history_importer.rb
module Swars
  module Importer
    class FullHistoryImporter < Base
      AccessList = [
        { imode_key: "通常",       xmode_key: "野良", rule_key: "10分", },
        { imode_key: "通常",       xmode_key: "野良", rule_key: "3分",  },
        { imode_key: "通常",       xmode_key: "野良", rule_key: "10秒", },
        { imode_key: "通常",       xmode_key: "友達", rule_key: "10分", },
        { imode_key: "通常",       xmode_key: "友達", rule_key: "3分",  },
        { imode_key: "通常",       xmode_key: "友達", rule_key: "10秒", },
        { imode_key: "通常",       xmode_key: "指導", rule_key: "10分", },
        { imode_key: "通常",       xmode_key: "大会", rule_key: "10分", },
        { imode_key: "通常",       xmode_key: "大会", rule_key: "3分",  },
        { imode_key: "通常",       xmode_key: "大会", rule_key: "10秒", },
        { imode_key: "スプリント", xmode_key: nil,    rule_key: nil,    },
      ]

      def call
        AccessList.each do |pattern|
          SingleHistoryImporter.new(params.merge(pattern)).call
        end
        latest_crawl_timestamps_update
      end

      private

      def latest_crawl_timestamps_update
        if user
          begin
            Retryable.retryable(on: ActiveRecord::Deadlocked) do
              if hard_crawl
                user.update_columns(soft_crawled_at: Time.current, hard_crawled_at: Time.current)
              else
                user.update_columns(soft_crawled_at: Time.current)
              end
            end
          rescue ActiveRecord::Deadlocked => error
            AppLog.important(error, data: params)
          end
        end
      end

      def user
        @user ||= User[params[:user_key]]
      end

      def hard_crawl
        SingleHistoryImporter.default_params.merge(params)[:hard_crawl]
      end
    end
  end
end
