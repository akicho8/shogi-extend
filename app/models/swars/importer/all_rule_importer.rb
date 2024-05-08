# AllRuleImporter.new(user_key: "alice", page_max: 3).run
# ~/src/shogi-extend/experiment/swars/all_rule_importer.rb
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
      end
    end
  end
end
