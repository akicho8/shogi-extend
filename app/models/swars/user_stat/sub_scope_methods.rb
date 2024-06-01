# frozen-string-literal: true

module Swars
  module UserStat
    module SubScopeMethods
      ################################################################################ win, lose

      # def wl_scope
      #   @wl_scope ||= Membership.where(id: ids_scope.joins(:battle).merge(Battle.win_lose_only).ids)
      # end
      #
      # def wl_count
      #   @wl_count ||= wl_scope.count
      # end

      ################################################################################ win

      def win_only
        @win_only ||= ids_scope.win_only
      end

      def win_count
        @win_count ||= win_only.count
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

      def d_count
        @d_count ||= draw_only.count
      end

      ################################################################################ other

      def win_ratio
        @win_ratio ||= yield_self do
          if ids_count.positive?
            win_count.fdiv(ids_count)
          end
        end
      end
    end
  end
end
