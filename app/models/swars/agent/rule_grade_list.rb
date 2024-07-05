module Swars
  module Agent
    class RuleGradeList
      GRADES_REGEXP = /(#{RuleInfo.collect(&:name).join("|")})\s*(\S+[級段])/o

      class << self
        def parse(text)
          new(text.scan(GRADES_REGEXP))
        end
      end

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

      def to_s
        oneline
      end
    end
  end
end
