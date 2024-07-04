module QuickScript
  concern :LoginUserMod do
    def admin_user
      @options[:admin_user]
    end

    def current_user
      @options[:current_user]
    end
  end
end
