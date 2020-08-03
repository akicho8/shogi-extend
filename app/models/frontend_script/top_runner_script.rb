module FrontendScript
  class TopRunnerScript < ::FrontendScript::Base
    self.script_name = "将棋ウォーズ急上昇者"

    def script_body
      ogp_params_set

      rows = user_keys.collect do |key|
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

          s = user.memberships.joins(:battle).merge(Swars::Battle.win_lose_only.newest_order).limit(latest_limit)
          s = Swars::Membership.where(id: s.ids)
          d = s.count
          w = s.where(judge_key: :win).count
          if d.positive?
            row[:win_ratio] = w.fdiv(d)
          end
        end
        row
      end

      rows = rows.sort_by { |e| -(e[:win_ratio] || 0) }

      if request.format.json?
        return rows
      end

      if rows.blank?
        return "今は棋士団イベント中なので何もでません"
      end

      rows.collect do |e|
        row = {}
        row["ウォーズID"] = h.link_to(e[:user][:name], [:swars, :battles, query: e[:user][:key]])
        row["最近の勝率"] = e[:win_ratio] ? "%.2f %%" % (e[:win_ratio] * 100) : nil
        row["棋譜数"] = e[:battles_count]
        row
      end
    end

    private

    def user_keys
      html = html_fetch("https://shogiwars.heroz.jp/", expires_in: 1.hour)
      doc = Nokogiri::HTML(html)
      doc.search("a").collect { |e|
        if md = e[:href].match(%r{/users/mypage/(\w+)})
          md.captures.first
        end
      }.compact
    end

    def latest_limit
      (params[:max].presence || 50).to_i
    end
  end
end
