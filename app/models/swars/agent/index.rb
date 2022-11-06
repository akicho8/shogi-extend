module Swars
  module Agent
    class Index < Base
      ITEMS_PER_PAGE = 10

      def default_params
        super.merge({
            :user_key       => nil,
            :rule_key       => :ten_min,
            :page_index     => 0,
            :items_per_page => ITEMS_PER_PAGE,
          })
      end

      def fetch
        if params[:verbose]
          puts "[fetch][index] #{url_path}"
        end
        # if params[:dry_run]
        #   return IndexResult.empty
        # end
        body = fetcher.fetch("index", url_path)
        if false
          # ウォーズIDのスペルミスは頻繁に起きる
          # そのとき例外を出すとエラーページまで飛んでしまう
          # そのためユーザーはスペルミスを修正することができない
          if !body || params[:SwarsUserNotFound]
            raise SwarsUserNotFound
          end
        else
          if params[:SwarsUserNotFound]
            body = ""
          end
          body ||= ""
        end
        keys = body.scan(/game_id=([\w-]+)/).flatten
        IndexResult.new(keys: keys, last_page: keys.size < params[:items_per_page])
      end

      private

      def url_path
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
        "/games/history?#{q.to_query}"
      end
    end
  end
end
