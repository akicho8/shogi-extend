# frozen-string-literal: true

module Swars
  module User::Stat
    class Base
      def initialize(stat)
        @stat = stat
      end

      private

      def assert_tag(tag)
        if Rails.env.local?
          unless tag.kind_of? Symbol
            raise "tag はシンボルにすること : #{tag.inspect}"
          end
          unless Bioshogi::Explain::TacticInfo.flat_lookup(tag)
            raise "存在しない : #{tag.inspect}"
          end
        end
      end

      def assert_judge_key(judge_key)
        if Rails.env.local?
          unless judge_key.kind_of? Symbol
            raise "judge_key はシンボルにすること : #{judge_key.inspect}"
          end
          JudgeInfo.fetch(judge_key)
        end
      end
    end
  end
end
