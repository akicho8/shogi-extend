module Api
  class TopGroupsController < ::Api::ApplicationController
    DEFAULT_LIMIT = 200

    # http://0.0.0.0:3000/api/top_group.json
    def show
      render json: Rails.cache.fetch(cache_key, expires_in: Rails.env.production? ? 1.hour : 0) { records }
    end

    private

    def cache_key
      [self.class.name, current_max].join("/")
    end

    def records
      records = user_keys.collect do |key|
        row = {}

        user = Swars::User.find_by(key: key)
        if user
          name = user.name_with_grade
        else
          name = key
        end
        row[:user] = { name: name, key: key }
        row[:battles_count] = nil
        if user
          row[:battles_count] = user.memberships.count

          # 最近の成績
          s = user.memberships
          s = s.joins(:battle)
          # s = s.merge(Swars::Battle.win_lose_only) # 勝敗があるものだけ
          s = s.merge(Swars::Battle.newest_order)  # 新しいもの順
          s = s.limit(current_max)
          row[:judge] = s.collect { |e| e.judge_info.ox_mark }.join

          row[:win]  = s.where(judge_key: :win).count
          row[:lose] = s.where(judge_key: :lose).count

          # 最近の勝率
          d = row[:win] + row[:lose]
          w = row[:win]
          if d.positive?
            row[:win_ratio] = w.fdiv(d)
          end
        end
        row
      end

      records.sort_by { |e| -(e[:win_ratio] || 0) }
    end

    private

    def user_keys
      keys = []

      body = html_fetch("https://shogiwars.heroz.jp/")
      doc = Nokogiri::HTML(body)

      # リンクのユーザー名が小文字化されているのでランキングの表示を取らないといけない
      keys += doc.search(".ranking_list dl").collect { |e|
        e.search("dd").first.text
      }

      # texts = doc.search("div.ranking_list dd").collect(&:text)
      # texts = texts.find_all { |e| e.match?(/[A-Z\d_]+\z/i) }
      # raise texts.inspect

      # 個人戦
      # keys += user_key_collect(doc, "a")

      # 団体戦
      keys += doc.search("a").flat_map { |e|
        if e[:href].match?(%r{/groups/})
          url = "https://shogiwars.heroz.jp#{e[:href]}"
          user_key_collect(Nokogiri::HTML(html_fetch(url)), ".boxMypage a")
        end
      }.compact

      # 念のためユニーク化
      keys.uniq
    end

    def user_key_collect(doc, selector)
      doc.search(selector).collect { |e|
        if e[:href]
          if md = e[:href].match(%r{/users/mypage/(\w+)})
            md.captures.first
          end
        end
      }.compact
    end

    def current_max
      (params[:max].presence || DEFAULT_LIMIT).to_i.clamp(0, DEFAULT_LIMIT)
    end
  end
end
