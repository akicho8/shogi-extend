module Swars
  module Agent
    class History < Base
      HISTORY_BASE_URL = "https://shogiwars.heroz.jp/games/history"

      def default_params
        super.merge({
            :imode_key  => :normal,
            :page_index => 0,
          })
      end

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
        HistoryResult.new(all_keys)
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
        user_key = params.fetch(:user_key)
        user_key.present? or raise "must not happen"
        user_key
      end

      def sw_side_gtype
        if v = params[:rule_key]
          RuleInfo.fetch(v).swars_magic_key
        end
      end

      def sw_side_page
        if v = params[:page_index]
          v.next
        end
      end

      def sw_side_opponent_type
        if v = (params[:xmode_key] || "野良")
          XmodeInfo.fetch(v).sw_side_key
        end
      end

      def sw_side_init_pos_type
        if v = params[:imode_key]
          ImodeInfo.fetch(v).swars_magic_key # FIXME: swars_magic_key を sw_side_key にする。ほかの swars_magic_key も置換する。
        end
      end
    end
  end
end
