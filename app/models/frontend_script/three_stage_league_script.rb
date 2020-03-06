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
      Rails.cache.fetch([self.class.name, current_generation], :expires_in => 1.hour) do
        begin
          html = URI(source_url).read
        rescue OpenURI::HTTPError => error
          return error.message
        end

        doc = Nokogiri::HTML(html.toutf8)
        users = doc.search("tbody tr").collect do |tr|
          values = tr.search("td").collect do |e|
            e.text.remove(/\p{Space}+/)
          end

          values = values.drop(2)
          user = [:name, :parent, :age, :win, :lose].zip(values).to_h
          user[:ox] = values.join.scan(/[○●]/).join

          [:age, :win, :lose].each do |e|
            user[e] = user[e].to_i
          end

          user
        end

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
          row = {}

          if user.has_key?(:rank)
            row[""] = user[:rank]
          end

          query = ["将棋", user[:name]].join(" ")
          row["名前"] = h.link_to("#{user[:name]}(#{user[:age]})", h.google_image_search_url(query))
          row["勝"]   = user[:win]
          row["勝敗"] = h.tag.div(user[:ox], :class => "fixed_font")
          row
        end

        [
          rows.to_html,
          h.link_to("本家", source_url, :class => "button is-small"),
        ].join(h.tag.br)
      end
    end

    def buttun_name
      "表示"
    end

    def source_url
      "https://www.shogi.or.jp/match/shoreikai/sandan/#{current_generation}/index.html"
    end

    def current_generation
      params[:generation].presence || LEAGUE_MATCH.last
    end
  end
end
