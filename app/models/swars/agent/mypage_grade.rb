module Swars
  module Agent
    class MypageGrade
      attr_accessor :list

      def initialize(list)
        @list = list.collect do |rule, grade|
          {
            :rule  => Swars::RuleInfo.fetch(rule),
            :grade => Swars::GradeInfo.fetch(grade),
          }
        end

        freeze
      end

      def valid?
        @list.any?
      end

      def invalid?
        @list.blank?
      end

      def ban?
        @list.any? { |e| e[:grade].ban? }
      end

      def oneline
        @list.collect { |e| e[:grade].name }.join(" ")
      end
    end
  end
end
