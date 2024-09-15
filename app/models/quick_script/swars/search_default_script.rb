module QuickScript
  module Swars
    class SearchDefaultScript < Base
      self.title = "将棋ウォーズ棋譜検索の検索初期値"
      self.description = "将棋ウォーズ棋譜検索の検索初期値を設定する"
      self.form_method = :post
      self.button_label = "保存"

      def form_parts
        super + [
          {
            :label   => "検索初期値",
            :key     => :swars_search_default_key,
            :type    => :string,
            :default => -> { swars_search_default_key }, # nil で送ったときだけ復帰するのでつまり URL 引数を優先する
            :ls_sync => { global_key: :swars_search_default_key, loader: :if_default_is_nil, writer: :force },
          },
        ]
      end

      def call
        if request_post?
          flash[:notice] = notice_message
          redirect_to "/swars/search"
        end
        nil
      end

      def swars_search_default_key
        params[:swars_search_default_key].to_s.strip.presence
      end

      def notice_message
        if swars_search_default_key
          "記憶しました"
        else
          "忘れました"
        end
      end
    end
  end
end
