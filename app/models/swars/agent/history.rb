module Swars
  module Agent
    class History < Base
      HISTORY_BASE_URL = "https://shogiwars.heroz.jp/games/history"

      def fetch
        if params[:verbose]
          puts "[fetch][history] #{history_url}"
        end
        # 対象のURLがなければ body は nil を返す
        body = fetcher.fetch(:history, history_url) || ""
        if params[:SwarsUserNotFound]
          body = ""
        end
        all_keys = body.scan(/\b(?:game_id)=([\w-]+)/).flatten.collect { |e| BattleKey.create(e) }
        HistoryBox.new(all_keys)
      end

      def history_url
        "#{HISTORY_BASE_URL}?#{sw_side_url_params.to_query}"
      end

      private

      def sw_side_url_params
        {
          :user_id       => sw_side_user_id,
          :gtype         => sw_side_gtype,
          :page          => sw_side_page,
          :init_pos_type => sw_side_init_pos_type,
          :opponent_type => sw_side_opponent_type,
        }.compact
      end

      def sw_side_user_id
        params[:user_key]
      end

      def sw_side_gtype
        if v = params[:rule_key]
          RuleInfo[v].sw_side_key
        end
      end

      def sw_side_page
        if v = params[:page_index]
          v.next
        end
      end

      def sw_side_opponent_type
        if v = params[:xmode_key]
          XmodeInfo[v].sw_side_key
        end
      end

      def sw_side_init_pos_type
        if v = params[:imode_key]
          ImodeInfo[v].sw_side_key
        end
      end
    end
  end
end
