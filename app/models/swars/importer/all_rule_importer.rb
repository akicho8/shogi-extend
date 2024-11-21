# AllRuleImporter.new(user_key: "alice", page_max: 3).run
# ~/src/shogi-extend/workbench/swars/all_rule_importer.rb
module Swars
  module Importer
    class AllRuleImporter
      attr_accessor :params

      def initialize(params = {})
        @params = {
        }.merge(params)
      end

      def run
        RuleInfo.each do |e|
          OneRuleImporter.new(params.merge(rule_key: e.key)).run
        end
        if user
          if early_break
            user.update_columns(soft_crawled_at: Time.current)
          else
            user.update_columns(soft_crawled_at: Time.current, hard_crawled_at: Time.current)
          end
        end
      end

      private

      def user
        @user ||= User[params[:user_key]]
      end

      def early_break
        OneRuleImporter.default_options.merge(params)[:early_break]
      end
    end
  end
end
