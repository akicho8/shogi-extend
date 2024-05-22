# frozen-string-literal: true

# FIXME: w_scope, l_scope で分けてもそんなに速くはならない

module Swars
  module UserStat
    module SubScopeMethods
      ################################################################################ win, lose

      def wl_scope
        @wl_scope ||= Membership.where(id: ids_scope.joins(:battle).merge(Battle.win_lose_only).ids)
      end

      def wl_count
        @wl_count ||= wl_scope.count
      end

      ################################################################################ win

      def w_scope
        @w_scope ||= ids_scope.s_where_judge_key_eq(:win)
      end

      def w_count
        @w_count ||= w_scope.count
      end

      ################################################################################ lose

      def l_scope
        @l_scope ||= ids_scope.s_where_judge_key_eq(:lose)
      end

      def l_count
        @l_count ||= l_scope.count
      end

      ################################################################################ draw

      def d_scope
        @d_scope ||= ids_scope.s_where_judge_key_eq(:draw)
      end

      def d_count
        @d_count ||= d_scope.count
      end

      ################################################################################ other

      def win_ratio
        @win_ratio ||= yield_self do
          if ids_count.positive?
            w_count.fdiv(ids_count)
          end
        end
      end
    end
  end
end
