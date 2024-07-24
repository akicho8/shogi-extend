module QuickScript
  module Account
    class InfoScript < Base
      self.title = "プロフィール"
      self.description = "プロフィールを表示する"
      self.nuxt_login_required_timing = :immediately
      self.login_link_show = true

      def call
        if current_user
          rows = [
            { "項目" => "名前",           "値" => current_user.name,                                                                             },
            { "項目" => "画像",           "値" => tag.figure(tag.img(src: current_user.avatar_url), :class => "image", :style => "width:128px"), },
            { "項目" => "メールアドレス", "値" => current_user.email,                                                                            },
            { "項目" => "SNS連携",        "値" => current_user.auth_infos.collect(&:provider).join(", "),                                        },
          ]
          # simple_table(rows, header_hide: true)
        end
      end
    end
  end
end
