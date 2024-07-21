module QuickScript
  concern :AutoexecMod do
    prepended do
      class_attribute :auto_exec_action, default: nil
    end

    def as_json(*)
      super.merge(auto_exec_action: auto_exec_action)
    end
  end
end
