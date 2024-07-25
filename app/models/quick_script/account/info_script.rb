module QuickScript
  module Account
    class InfoScript < Base
      self.title = "プロフィール"
      self.description = "プロフィールを表示する"
      self.nuxt_login_required_timing = :immediately
      self.login_link_show = true
      self.sideber_menu_show = true

      def call
        if current_user
          rows = [
            { "項目" => "名前",                "値" => current_user.name,                                                                             },
            { "項目" => "画像",                "値" => tag.figure(tag.img(src: current_user.avatar_url), :class => "image", :style => "width:128px"), },
            { "項目" => "メールアドレス",      "値" => current_user.email,                                                                            },
            { "項目" => "SNSアカウント連携先", "値" => current_user.auth_infos.collect(&:provider).join(", "),                                        },
          ]
          # simple_table(rows, header_hide: true)
        end
      end

      # def sideber_menu_groups
      #   super + [
      #     {
      #       :group_name => "Action",
      #       :menu_items => [
      #         { :label => "プロフィール編集",   :tag => "nuxt-link", :to => {name: "settings-profile"    }, },
      #         { :label => "メールアドレス変更", :tag => "nuxt-link", :to => {name: "settings-email"      }, },
      #         { :label => "ぴよ将棋の種類",     :tag => "nuxt-link", :to => {name: "settings-piyo_shogi" }, },
      #       ],
      #     },
      #     {
      #       :group_name => "その他",
      #       :menu_items => [
      #         { :label => "SNSアカウント連携",   :href => "#{self.class.api_server_root_url}accounts/#{current_user&.id}/edit", },
      #         { :label => "ログアウト",       :tag => "nuxt-link", :to => {path: "/lab/account/logout"},                     },
      #         { :label => "退会",             :tag => "nuxt-link", :to => {path: "/lab/account/destroy"},                    },
      #       ],
      #     },
      #   ]
      # end
    end
  end
end
