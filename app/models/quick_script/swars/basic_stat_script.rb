# rails r QuickScript::Swars::BasicStatScript.new.cache_all
module QuickScript
  module Swars
    class BasicStatScript < Base
      self.title = "統計"
      self.description = "将棋ウォーズの対局から何かを調べる"

      def call
        if Rails.env.local?
          cache_clear
        end
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

      def cache_all
        delegate_objects.each(&:cache_write)
      end

      def cache_clear
        delegate_objects.each(&:cache_clear)
      end

      def main_scope_on_development
        @main_scope_on_development ||= yield_self do
          if Rails.env.local?
            ::Swars::Membership.where(id: ::Swars::Membership.last(1000).collect(&:id))
          end
        end
      end
    end
  end
end
