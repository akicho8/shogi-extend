# http://localhost:4000/lab/admin/dashboard

module QuickScript
  module Admin
    class DashboardScript < Base
      self.title = "ダッシュボード"
      self.description = ""
      self.title_click_behaviour = :force_reload

      RORVSWILD_URLS = {
        "test"        => "https://www.rorvswild.com/applications/136518/requests?range=1h",
        "development" => "https://www.rorvswild.com/applications/136518/requests?range=1h",
        "staging"     => "https://www.rorvswild.com/applications/136520/requests?range=1h",
        "production"  => "https://www.rorvswild.com/applications/136519/requests?range=1h",
      }

      def header_link_items
        super + [
          { name: "RorVsWild",   _v_bind: { href: RORVSWILD_URLS[Rails.env],                         target: "_blank" }, },
          { name: "Sidekiq",     _v_bind: { href: UrlProxy.full_url_for("/admin/sidekiq"),           target: "_blank" }, },
          { name: "Maintenance", _v_bind: { href: UrlProxy.full_url_for("/admin/maintenance_tasks"), target: "_blank" }, },
          { name: "GA",          _v_bind: { href: "https://analytics.google.com/analytics/web/#/a109851345p350440237/reports/intelligenthome", target: "_blank" }, },
          { name: "Top",         _v_bind: { href: UrlProxy.full_url_for("/"),                        target: "_blank" }, },
        ]
      end

      def call
        tag.div(:class => "columns is-mobile is-multiline") do
          computed_items.collect { |item, result, duration|
            tag.div(:class => "column is-2") do
              name = tag.div("#{item.name} #{duration.round(1)}s", :class => "is-size-7")
              if result.kind_of? Integer
                result = ActiveSupport::NumberHelper.number_to_delimited(result)
              end
              body = tag.div(result, :class => "has-text-weight-bold is-size-3")
              content = [name, body].join.html_safe

              options = { :class => "box has-text-centered" }
              if item.href
                tag.a(content, href: item.href, target: "_blank", **options)
              else
                tag.div(content, **options)
              end
            end
          }.join.html_safe
        end
      end

      def prepare_aggregation_cache
        rows = DashboardItemInfo.find_all(&:cache_expires_in).collect do |item|
          duration = TimeTrial.second { item.result }
          { "項目" => item.name, "実行時間" => ActiveSupport::Duration.build(duration).inspect }
        end
        AppLog.info(subject: "[ダッシュボード][事前集計]", body: rows.to_t)
      end

      private

      def computed_items
        DashboardItemInfo.collect do |item|
          result = nil
          duration = TimeTrial.second { result = item.result }
          [item, result, duration]
        end
      end
    end
  end
end
