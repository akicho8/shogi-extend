# rails r QuickScript::Swars::BasicStatScript.new.cache_write
module QuickScript
  module Swars
    class BasicStatScript < Base
      self.title = "統計"
      self.description = "将棋ウォーズの対局から何かを調べる"

      def call
        v_stack(delegate_objects.collect(&:to_component))
      end

      def sprintha_gotegatuyoi_noka
        @sprintha_gotegatuyoi_noka ||= SprinthaGotegatuyoiNoka.new(self)
      end

      def grade_each_sprint_win_rate
        @grade_each_sprint_win_rate ||= GradeEachSprintWinRate.new(self)
      end

      def delegate_objects
        [
          sprintha_gotegatuyoi_noka,
          grade_each_sprint_win_rate,
        ]
      end

      def cache_write
        delegate_objects.each(&:cache_write)
      end

      def cache_fetch
        delegate_objects.each(&:cache_fetch)
      end

      def cache_clear
        delegate_objects.each(&:cache_clear)
      end
    end
  end
end
