module QuickScript
  concern :AutoexecMod do
    prepended do
      class_attribute :auto_exec_action, default: nil # DEPLICATE
      class_attribute :auto_exec_code, default: nil
    end

    def as_json(*)
      super.merge(auto_exec_action: auto_exec_action)
      super.merge(auto_exec_code: auto_exec_code)
    end

    def session_reload!
      self.auto_exec_action = "a_auth_user_fetch"
    end

    def piyo_shogi_reload!
      self.auto_exec_code = "this.$PiyoShogiTypeCurrent.reload()"
    end
  end
end
