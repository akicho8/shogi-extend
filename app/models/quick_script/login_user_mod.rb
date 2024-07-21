module QuickScript
  concern :LoginUserMod do
    prepended do
      class_attribute :nuxt_login_required_timing, default: nil # 「ログインせよ」をどのタイミングで出すか？ nil | immediately | later
    end

    def as_json(*)
      super.merge(nuxt_login_required_timing: nuxt_login_required_timing)
    end

    def current_user
      @options[:current_user]
    end

    def admin_user
      @options[:admin_user]
    end
  end
end
