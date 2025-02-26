module Swars
  module Agent
    class History < Base
      HISTORY_BASE_URL = "https://shogiwars.heroz.jp/games/history"

      def default_params
        super.merge({
            :user_key   => nil,
            :rule_key   => :ten_min,
            :xmode2_key => nil,
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
          :user_id => sw_side_user_id,
          :gtype   => sw_side_gtype,
          :page    => sw_side_page,
          :init_pos_type => sw_side_init_pos_type,
        }.compact_blank
      end

      def sw_side_user_id
        user_key = params.fetch(:user_key)
        if user_key.blank?
          raise "must not happen"
        end
        user_key
      end

      def sw_side_gtype
        RuleInfo.fetch(params.fetch(:rule_key)).swars_magic_key
      end

      def sw_side_page
        if v = params[:page_index]
          v.next
        end
      end

      def sw_side_init_pos_type
        if v = params.fetch(:xmode2_key)
          Xmode2Info.fetch(v).swars_magic_key
        end
      end
    end
  end
end
