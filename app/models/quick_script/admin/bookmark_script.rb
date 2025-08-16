# http://localhost:4000/lab/admin/bookmark

module QuickScript
  module Admin
    class BookmarkScript < Base
      self.title = "ブックマーク"
      self.description = ""

      def call
        [
          { "Site" => { _link_to: "Top",                  _v_bind: { href: UrlProxy.full_url_for("/"), target: "_blank" }, }, },
          { "Site" => { _link_to: "Sidekiq",              _v_bind: { href: UrlProxy.full_url_for("/admin/sidekiq"), target: "_blank" }, }, },
          { "Site" => { _link_to: "MaintenanceTasks",     _v_bind: { href: UrlProxy.full_url_for("/admin/maintenance_tasks"), target: "_blank" }, }, },
          { "Site" => { _link_to: "Rorvswild local",      _v_bind: { href: "https://www.rorvswild.com/applications/136518/requests?range=1h", target: "_blank" }, }, },
          { "Site" => { _link_to: "Rorvswild staging",    _v_bind: { href: "https://www.rorvswild.com/applications/136520/requests?range=1h", target: "_blank" }, }, },
          { "Site" => { _link_to: "Rorvswild production", _v_bind: { href: "https://www.rorvswild.com/applications/136519/requests?range=1h", target: "_blank" }, }, },
        ]
      end
    end
  end
end
