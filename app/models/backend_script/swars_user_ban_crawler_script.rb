module BackendScript
  class SwarsUserBanCrawlerScript < ::BackendScript::Base
    include AtomicScript::PostRedirectMethods
    include SwarsUser::SearchMethods

    self.category = "swars"
    self.script_name = "棋譜検索 ユーザー 垢BAN クローラー発動"

    def form_parts
      super + [
        {
          :label       => "本家への負荷制限用 sleep 値(localを除く)",
          :key         => :sleep,
          :type        => :string,
          :default     => current_sleep,
        },
        {
          :label       => "実行確認",
          :right_label => "本当にクロールしてDBを更新する",
          :key         => :execute,
          :type        => :boolean,
          :default     => current_execute,
        },
      ]
    end

    def script_body
      if submitted?
        if !current_execute
          s = Swars::User.search(swars_user_search_query)
          s = s.order(:created_at, :id)
          s = page_scope(s)
          rows = s.collect(&:to_h)
          out = "".html_safe
          out << rows.to_html
          out << basic_paginate(s)
        else
          SwarsBanCrawlerJob.perform_later(swars_ban_crawler_options)
          out = "".html_safe
          out << swars_ban_crawler_options.to_html
          out << params.to_html
        end
      end
    end

    # see: Swars::BanCrawler
    def swars_ban_crawler_options
      {
        :query   => swars_user_search_query,
        :sleep   => current_sleep,
        :execute => current_execute,
      }
    end

    def current_sleep
      (params[:sleep].presence || 1.0).to_f
    end

    def current_execute
      params[:execute] == "true"
    end
  end
end
