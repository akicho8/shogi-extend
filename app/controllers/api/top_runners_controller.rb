module Api
  class TopRunnersController < ::Api::ApplicationController
    DEFAULT_LIMIT = 50

    # http://0.0.0.0:3000/api/top_runner.json
    def show
      render json: Rails.cache.fetch(cache_key, expires_in: Rails.env.production? ? 1.hour : 0) { records }
    end

    private

    def cache_key
      self.class.name
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

      doc = Nokogiri::HTML(html_fetch("https://shogiwars.heroz.jp/"))

      # 個人戦
      keys += user_key_collect(doc, "a")

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

# module Api
#   class ProfessionalsController < ::Api::ApplicationController
#     # http://0.0.0.0:3000/api/professional.json
#     def show
#       render json: Rails.cache.fetch(cache_key, expires_in: Rails.env.production? ? 1.days : 0) {
#         rows
#       }
#       # rows.collect do |e|
#       #   {}.tap do |row|
#       #     row["名前"] = h.link_to(e[:user][:name], [:swars, :battles, query: e[:user][:key]])
#       #     row["勝敗"] = h.tag.span(e[:judge], :class => "ox_sequense is_line_break_on")
#       #   end
#       # end
#     end
#
#     def cache_key
#       self.class.name
#     end
#
#     def rows
#       user_infos_hash = user_infos_fetch.inject({}) { |a, e| a.merge(e[:key].downcase => e) }
#
#       grade = Swars::Grade.find_by!(key: "十段")
#       users = Swars::User.where(grade: grade).order(created_at: :desc).includes(:memberships).joins(:memberships) # joins を取るとデータがないデータも表示できる
#
#       if Rails.env.development? || Rails.env.test?
#         users = Swars::User.all
#       end
#
#       users.collect do |user|
#         {}.tap do |row|
#           name = user.key
#           if user_info = user_infos_hash[user.key.downcase]
#             if s = user_info["名前"].to_s.remove(/\s*\<.*?\>/).presence
#               name = s
#             end
#           end
#           row[:user] = { name: name, key: user.key }
#           row[:judge] = user.memberships.joins(:battle).order(Swars::Battle.arel_table[:battled_at]).collect { |e| e.judge_info.ox_mark }.join
#         end
#       end
#     end
#
#     def user_infos_fetch
#       rows = []
#       256.times.with_index(1) do |_, page|
#         html = html_fetch(page) # 404 にはならず空データが返ってくる
#         doc = Nokogiri::HTML(html)
#         list = doc.search("#coach_list li")
#         if list.empty?
#           break
#         end
#         rows += list.collect do |e|
#           {}.tap do |row|
#             row[:key] = e.at(".coach_name a").text
#             e.search("tr").each do |e|
#               key = e.at("th").text
#               val = e.at("td").text.squish
#               row[key] = val
#             end
#           end
#         end
#       end
#       rows
#     end
#
#     def html_fetch(page)
#       url = "https://shogiwars.heroz.jp/premium/coach_list?page=#{page}"
#       Rails.cache.fetch(url, :expires_in => 1.days) do
#         URI(url).read.toutf8
#       end
#     end
#   end
# end
