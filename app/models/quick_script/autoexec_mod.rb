module QuickScript
  concern :AutoexecMod do
    prepended do
      class_attribute :fetch_then_auto_exec_action, default: nil
    end

    def as_json(*)
      super.merge(fetch_then_auto_exec_action: fetch_then_auto_exec_action)
    end
  end
end
