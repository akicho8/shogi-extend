module BackendScript
  concern :SwarsUserSearchMethods do
    included do
    end

    class_methods do
    end

    def form_parts
      super + [
        {
          :label       => "段級位で絞る",
          :key         => :grade_keys,
          :type        => :check_box,
          :elems       => Swars::GradeInfo.find_all(&:show_in_search_script).inject({}) { |a, e| a.merge(e.key => e.name) },
          :default     => current_grade_keys,
        },
        {
          :label       => "ウォーズIDsで絞る",
          :key         => :user_keys,
          :type        => :string,
          :default     => params[:user_keys],
        },
        {
          :label       => "データベース上のIDsで絞る",
          :key         => :ids,
          :type        => :string,
          :default     => params[:ids],
        },
        {
          :label       => "件数制限",
          :key         => :limit,
          :type        => :string,
          :default     => current_limit,
        },
        {
          :label       => "垢BAN確認回数X回以下を対象とする (初回なら0)",
          :key         => :ban_crawled_count_lteq,
          :type        => :string,
          :default     => current_ban_crawled_count_lteq,
        },
        {
          :label       => "前回の垢BANチェックからN日経過している",
          :key         => :ban_crawled_at_lt,
          :type        => :string,
          :default     => params[:ban_crawled_at_lt].presence,
        },
        {
          :label       => "最終対局からN日経過している",
          :key         => :latest_battled_at_lt,
          :type        => :string,
          :default     => params[:latest_battled_at_lt].presence,
        },
        {
          :label       => "垢BANチェック後に対局した人",
          :right_label => "絞る",
          :key         => :ban_crawl_then_battled,
          :type        => :boolean,
          :default     => params[:ban_crawl_then_battled],
        },
        {
          :label       => "垢BAN (牢獄者)",
          :right_label => "絞る",
          :key         => :ban_only,
          :type        => :boolean,
          :default     => params[:ban_only],
        },
        {
          :label       => "垢BANされていない人たち",
          :right_label => "絞る",
          :key         => :ban_except,
          :type        => :boolean,
          :default     => params[:ban_except],
        },
      ]
    end

    # see: Swars::BanCrawler
    def swars_user_search_query
      {
        :ids                    => current_ids,
        :grade_keys             => current_grade_keys,
        :user_keys              => current_user_keys,
        :limit                  => current_limit,
        :ban_crawled_count_lteq => current_ban_crawled_count_lteq,
        :ban_crawled_at_lt      => current_ban_crawled_at_lt,
        :latest_battled_at_lt   => current_latest_battled_at_lt,
        :ban_crawl_then_battled => current_ban_crawl_then_battled,
        :ban_only               => current_ban_only,
        :ban_except             => current_ban_except,
      }
    end

    def current_grade_keys
      params[:grade_keys].presence
    end

    def current_user_keys
      params[:user_keys].to_s.scan(/\w+/).presence
    end

    def current_limit
      if v = params[:limit].presence
        v.to_i
      end
    end

    def current_ban_crawled_count_lteq
      if v = params[:ban_crawled_count_lteq].presence
        v.to_i
      end
    end

    def current_ban_crawl_then_battled
      params[:ban_crawl_then_battled] == "true"
    end

    def current_ban_crawled_at_lt
      if v = params[:ban_crawled_at_lt].presence
        v.to_i.days.ago
      end
    end

    def current_latest_battled_at_lt
      if v = params[:latest_battled_at_lt].presence
        v.to_i.days.ago
      end
    end

    def current_ban_crawl_then_battled
      params[:ban_crawl_then_battled] == "true"
    end

    def current_ban_only
      params[:ban_only] == "true"
    end

    def current_ban_except
      params[:ban_except] == "true"
    end

    def current_ids
      if v = params[:ids].presence
        v.scan(/\d+/).collect(&:to_i)
      end
    end
  end
end
