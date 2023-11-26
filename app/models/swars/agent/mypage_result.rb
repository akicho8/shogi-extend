module Swars
  module Agent
    class MypageResult
      attr_accessor :list

      def initialize(list)
        @list = list.collect do |rule, grade|
          {
            rule: Swars::RuleInfo.fetch(rule),
            grade: Swars::GradeInfo.fetch(grade),
          }
        end

        freeze
      end

      def ban?
        @list.any? { |e| e[:grade] == GradeInfo.ban }
      end

      def inspect
        @list.to_t
      end

      def oneline
        @list.collect { |e| e[:grade].name }.join(" ")
      end
    end
  end
end
