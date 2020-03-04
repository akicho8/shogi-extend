module FrontendScript
  class TopRunnerScript < ::FrontendScript::Base
    self.script_name = "トップランナー"

    def script_body
      Rails.cache.fetch(self.class.name, :expires_in => 1.hour) do
        html = URI("https://shogiwars.heroz.jp/").read
        doc = Nokogiri::HTML(html)
        keys = doc.search("a").collect { |e|
          if md = e[:href].match(%r{/users/mypage/(\w+)})
            md.captures.first
          end
        }.compact

        keys.collect do |key|
          row = {}

          user = Swars::User.find_by(key: key)
          if user
            name = user.name_with_grade
          else
            name = key
          end

          row["ウォーズID"] = h.link_to(name, [:swars, :battles, query: key])

          count = 0
          if user
            count = Swars::Membership.where(user: user).count
          end
          row["棋譜数"] = count

          row
        end
      end
    end
  end
end
