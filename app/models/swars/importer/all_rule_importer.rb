# AllRuleImporter.new(user_key: "alice", page_max: 3).run

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
          OneRuleImporter.new(params.merge(gtype: e.swars_real_key)).run
        end
      end
    end
  end
end
