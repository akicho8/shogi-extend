# AllRuleImporter.new(user_key: "alice", page_max: 3).run
# ~/src/shogi-extend/workbench/swars/all_rule_importer.rb
module Swars
  module Importer
    class AllRuleImporter
      WITH_SPRINT = true

      attr_accessor :params

      def initialize(params = {})
        @params = {
        }.merge(params)
      end

      def run
        RuleInfo.each do |e|
          OneRuleImporter.new(params.merge(rule_key: e.key)).run
        end
        if WITH_SPRINT
          OneRuleImporter.new(params.merge(xmode2_key: :sprint)).run
        end
        after_process
      end

      private

      def after_process
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
        OneRuleImporter.default_options.merge(params)[:hard_crawl]
      end
    end
  end
end
