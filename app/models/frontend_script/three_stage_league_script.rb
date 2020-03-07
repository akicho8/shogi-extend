module FrontendScript
  class ThreeStageLeagueScript < ::FrontendScript::Base
    self.script_name = "奨励会三段リーグ"

    RANKING_ENABLE = false
    LEAGUE_MATCH = 28..66

    def form_parts
      [
        {
          :label   => "第？回",
          :key     => :generation,
          :elems   => LEAGUE_MATCH.to_a.reverse,
          :type    => :select,
          :default => current_generation,
        },
      ]
    end

    def script_body
      if users = user_infos_fetch
        users = users.sort_by { |e| -e[:win] }

        # ランキング追加
        if RANKING_ENABLE
          redis = Redis.new(db: AppConfig[:redis_db_for_colosseum_ranking_info])
          redis.del(self.class.name)
          users.each do |user|
            redis.zadd(self.class.name, user[:win], user[:name])
          end
          ranking = redis.zrevrange(self.class.name, 0, -1, with_scores: true)
          users.each do |user|
            user[:rank] = redis.zcount(self.class.name, user[:win] + 1, "+inf") + 1
          end
          redis.del(self.class.name)
        end

        rows = users.collect do |user|
          {}.tap do |row|
            if v = user[:rank]
              row[""] = v
            end

            name = user[:name]
            if v = user[:age]
              name += "(#{v})"
            end
            query = ["将棋", user[:name]].join(" ")
            row["名前"] = h.link_to(name, h.google_image_search_url(query))

            row["勝"]   = user[:win]

            row["勝敗"] = h.tag.span(user[:ox], :class => "line_break_on")
          end
        end

        [
          rows.to_html,
          h.link_to("本家", source_url, :class => "button is-small"),
        ].join(h.tag.br)

      end
    end

    def user_infos_fetch
      if html = html_fetch
        doc = Nokogiri::HTML(html)
        doc.search("tbody tr").collect do |tr|
          {}.tap do |user|
            values = tr.search("td").collect do |e|
              e.text.remove(/\p{Space}+/)
            end

            values = values.drop(2)

            # 昔と今でフォーマットが異なる
            # ・昔 https://www.shogi.or.jp/match/shoreikai/sandan/28/index.html
            # ・今 https://www.shogi.or.jp/match/shoreikai/sandan/66/index.html
            if current_generation < 31
              user.update([:name, :win, :lose].zip(values).to_h)
            else
              user.update([:name, :parent, :age, :win, :lose].zip(values).to_h)
            end

            user[:ox] = values.join.scan(/[○●]/).join

            # # 勝敗のマークから勝数を調べる
            # user[:win]  = user[:ox].count("○")
            # user[:lose] = user[:ox].count("●")

            [:age, :win, :lose].each do |e|
              if v = user[e]
                user[e] = v.to_i
              end
            end
          end
        end
      end
    end

    def buttun_name
      "表示"
    end

    def source_url
      "https://www.shogi.or.jp/match/shoreikai/sandan/#{current_generation}/index.html"
    end

    def current_generation
      (params[:generation].presence || LEAGUE_MATCH.last).to_i
    end

    def html_fetch
      Rails.cache.fetch(source_url, :expires_in => 1.hour) do
        begin
          URI(source_url).read.toutf8 # この時点で UTF-8 にしておかないと fastentry が死ぬ
        rescue OpenURI::HTTPError
        end
      end
    end
  end
end
