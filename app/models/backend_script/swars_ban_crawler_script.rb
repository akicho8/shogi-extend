module BackendScript
  class SwarsBanCrawlerScript < ::BackendScript::Base
    include AtomicScript::PostRedirectMethods

    self.category = "swars"
    self.script_name = "将棋ウォーズ棋譜検索 垢BAN クローラー発動"

    def form_parts
      [
        {
          :label       => "段級位で絞る",
          :key         => :grade_keys,
          :type        => :check_box,
          :elems       => Swars::GradeInfo.find_all(&:ban_check).inject({}) { |a, e| a.merge(e.key => e.name) },
          :default     => current_grade_keys,
        },
        {
          :label       => "ウォーズIDsで絞る",
          :key         => :user_keys,
          :type        => :string,
          :default     => params[:user_keys],
        },
        {
          :label       => "件数制限",
          :key         => :limit,
          :type        => :string,
          :default     => current_limit || 1000,
        },
        {
          :label       => "確認回数N回以下を対象とする (初回なら0)",
          :key         => :ban_crawled_count_lteq,
          :type        => :string,
          :default     => current_ban_crawled_count_lteq || 0,
        },
        {
          :label       => "本家への負荷制限用 sleep 値(localを除く)",
          :key         => :sleep,
          :type        => :string,
          :default     => current_sleep,
        },
        {
          :label       => "実行確認 (これに関係なく本番では本家にアクセスがいく)",
          :right_label => "本当にDBを更新する",
          :key         => :execute,
          :type        => :boolean,
          :default     => current_execute,
        },
      ]
    end

    def script_body
      if submitted?
        SwarsBanCrawlerJob.perform_later(swars_ban_crawler_options)
        params
        # AppLog.order(created_at: :desc).take(10)
      end
    end

    # see: Swars::BanCrawler
    def swars_ban_crawler_options
      {
        :grade_keys           => current_grade_keys,
        :user_keys            => current_user_keys,
        :limit                => current_limit,
        :sleep                => current_sleep,
        :ban_crawled_count_lteq => current_ban_crawled_count_lteq,
        :execute              => current_execute,
      }
    end

    def current_grade_keys
      params[:grade_keys].presence
    end

    def current_user_keys
      params[:user_keys].to_s.scan(/\w+/).presence
    end

    def current_limit
      (params[:limit].presence)&.to_i
    end

    def current_sleep
      (params[:sleep].presence || 1.0)&.to_f
    end

    def current_ban_crawled_count_lteq
      (params[:ban_crawled_count_lteq].presence)&.to_i
    end

    def current_execute
      params[:execute] == "true"
    end
  end
end
