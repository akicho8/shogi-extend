# frozen-string-literal: true

module Swars
  module User::Stat
    concern :SubScopeMethods do
      included do
        self::DELEGATE_METHODS.concat [
          :win_only,
          :win_count,
          :lose_only,
          :lose_count,
          :draw_only,
          :draw_count,
          :win_ratio,
        ]
      end

      ################################################################################ win

      def win_only
        @win_only ||= ids_scope.win_only
      end

      def win_count
        @win_count ||= win_only.count
      end

      def win_ratio
        @win_ratio ||= yield_self do
          if ids_count.positive?
            win_count.fdiv(ids_count)
          else
            0.0
          end
        end
      end

      ################################################################################ lose

      def lose_only
        @lose_only ||= ids_scope.lose_only
      end

      def lose_count
        @lose_count ||= lose_only.count
      end

      ################################################################################ draw

      def draw_only
        @draw_only ||= ids_scope.draw_only
      end

      def draw_count
        @draw_count ||= draw_only.count
      end

      ################################################################################
    end
  end
end
