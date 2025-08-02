# http://localhost:4000/lab/admin/dashboard

module QuickScript
  module Admin
    class DashboardScript < Base
      self.title = "ダッシュボード"
      self.description = ""
      self.title_click_behaviour = :force_reload

      def call
        tag.div(:class => "columns is-mobile is-multiline") do
          DashboardItemInfo.collect { |item|
            tag.div(:class => "column is-2") do
              box_html = tag.div(:class => "box has-text-centered") do
                body = nil
                sec = TimeTrial.realtime do
                  if item.expires_in
                    expires_in = Rails.env.production? ? item.expires_in : item.expires_in
                    body = Rails.cache.fetch("DashboardItemInfo/#{item.key}", expires_in: expires_in) do
                      instance_exec(&item.func)
                    end
                  else
                    body = instance_exec(&item.func)
                  end
                end
                body = tag.div(body, :class => "has-text-weight-bold is-size-3")

                name = item.name
                if item.expires_in
                  name = "*#{name}"
                end
                name = "#{name} #{sec.round(1)}s"
                name = tag.div(name, :class => "is-size-7")

                [name, body].join.html_safe
              end
              if item.href
                box_html = tag.a(box_html, href: item.href, target: "_blank")
              end
              box_html
            end
          }.join.html_safe
        end
      end
    end
  end
end
