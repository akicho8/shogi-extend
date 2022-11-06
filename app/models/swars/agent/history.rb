module Swars
  module Agent
    class History < Base
      def default_params
        super.merge({
            :user_key   => nil,
            :rule_key   => :ten_min,
            :page_index => 0,
          })
      end

      def fetch
        if params[:verbose]
          puts "[fetch][history] #{originator_url}"
        end
        # 対象のURLがなければ body は nil を返す
        body = fetcher.fetch(:history, originator_url) || ""
        if params[:SwarsUserNotFound]
          body = ""
        end
        all_keys = body.scan(/game_id=([\w-]+)/).flatten.collect { |e| KeyVo.wrap(e) }
        HistoryResult.new(all_keys)
      end

      private

      def originator_url
        user_key = params.fetch(:user_key)
        if user_key.blank?
          raise "must not happen"
        end
        q = {}
        q[:user_id] = user_key
        q[:gtype]   = RuleInfo.fetch(params.fetch(:rule_key)).swars_magic_key
        if v = params[:page_index]
          q[:page] = v.next
        end
        "https://shogiwars.heroz.jp/games/history?#{q.to_query}"
      end
    end
  end
end
