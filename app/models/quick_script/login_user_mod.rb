module QuickScript
  concern :LoginUserMod do
    prepended do
      class_attribute :button_with_nuxt_login_required, default: :button_with_nuxt_login_required1 # ボタンを押したタイミングで nuxt_login_required を発動させる？
    end

    def as_json(*)
      super.merge(button_with_nuxt_login_required: button_with_nuxt_login_required)
    end

    def current_user
      @options[:current_user]
    end

    def admin_user
      @options[:admin_user]
    end
  end
end
