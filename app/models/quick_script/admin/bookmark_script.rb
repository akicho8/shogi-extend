# http://localhost:4000/lab/admin/share_board_battle_index2

module QuickScript
  module Admin
    class BookmarkScript < Base
      self.title = "ブックマーク"
      self.description = ""

      def call
        [
          { "Site" => { _link_to: "Sidekiq", _v_bind: { href: UrlProxy.full_url_for("/admin/sidekiq") }, }, },
        ]
      end
    end
  end
end
