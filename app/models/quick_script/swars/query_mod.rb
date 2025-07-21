module QuickScript
  module Swars
    concern :QueryMod do
      def form_part_for_query
        {
          :label        => "検索クエリ",
          :key          => :query,
          :type         => :string,
          :session_sync => true,
          :dynamic_part => -> {
            {
              :default      => query,
              :placeholder  => "BOUYATETSU5 勝敗:勝ち tag:右四間飛車",
              :help_message => "将棋ウォーズ棋譜検索側と同じ検索クエリを指定できる",
            }
          },
        }
      end

      ################################################################################

      def swars_user_key
        query_info.swars_user_key
      end

      def swars_user
        @swars_user ||= swars_user_key.try { db_record }
      end

      ################################################################################

      def query
        params[:query].to_s.squish
      end

      def query_info
        @query_info ||= QueryInfo.parse(query)
      end

      def query_scope
        @query_scope ||= ::Swars::QueryResolver.resolve(current_swars_user: swars_user, query_info: query_info)
      end

      ################################################################################
    end
  end
end
