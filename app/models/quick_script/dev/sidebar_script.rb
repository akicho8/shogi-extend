module QuickScript
  module Dev
    class SidebarScript < Base
      self.title = "サイドバー表示"
      self.description = "サイドバーを表示する"
      self.login_link_show = true
      self.sideber_menu_show = true

      def sideber_menu_groups
        super + [
          {
            :group_name => "Action",
            :menu_items => [
              { :label => "プロフィール編集",   :tag => "nuxt-link", :to => {name: "settings-profile"    }, },
              { :label => "メールアドレス変更", :tag => "nuxt-link", :to => {name: "settings-email"      }, },
              { :label => "ぴよ将棋の種類",     :tag => "nuxt-link", :to => {name: "settings-piyo_shogi" }, },
            ],
          },
          {
            :group_name => "その他",
            :menu_items => [
              { :label => "アカウント連携",   :href => url_helpers.edit_user_url(current_user&.id || 1), },
              { :label => "ログアウト",       :tag => "nuxt-link", :to => {path: "/lab/account/logout"}, },
              { :label => "退会",             :tag => "nuxt-link", :to => {path: "/lab/account/destroy"},},
            ],
          },
        ]
      end
    end
  end
end
