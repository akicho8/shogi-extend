module QuickScript
  module Swars
    concern :QueryMod do
      def form_part_for_query
        {
          :label        => "検索クエリ",
          :key          => :query,
          :type         => :string,
          :default      => query,
          :placeholder  => "BOUYATETSU5 勝敗:勝ち tag:右四間飛車",
          :help_message => "将棋ウォーズ棋譜検索側と同じ検索クエリを指定できる",
          :session_sync => true,
    }
      end

      ################################################################################

      def swars_user_key_default
        @swars_user_key_default ||= yield_self do
          if debug_mode
            ::Swars::UserKey["BOUYATETSU5"]
          end
        end
      end

      def swars_user_key
        query_info.swars_user_key || swars_user_key_default
      end

      def swars_user
        @swars_user ||= swars_user_key.db_record
      end

      ################################################################################

      def query
        params[:query].to_s
      end

      def query_info
        @query_info ||= QueryInfo.parse(query)
      end

      def query_scope
        @query_scope ||= swars_user.battles.find_all_by_params(query_info: query_info, target_owner: swars_user)
      end

      ################################################################################
    end
  end
end
