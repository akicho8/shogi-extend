module QuickScript
  concern :LoginUserMod do
    prepended do
      class_attribute :nuxt_login_required_timing, default: nil   # 「ログインせよ」を出すタイミング nil | immediately | later
      class_attribute :login_link_show,            default: false # プロフィール画像やログインリンクを表示するか？
    end

    def as_json(*)
      super.merge({
          :nuxt_login_required_timing => nuxt_login_required_timing,
          :login_link_show            => login_link_show,
        })
    end

    def current_user
      @options[:current_user]
    end

    def admin_user
      @options[:admin_user]
    end
  end
end
