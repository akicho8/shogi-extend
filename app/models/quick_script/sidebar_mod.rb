module QuickScript
  concern :SidebarMod do
    prepended do
      class_attribute :sideber_menu_show, default: false
      class_attribute :sideber_menu_groups, default: []
    end

    def as_json(*)
      super.merge({
          :sideber_menu_show => sideber_menu_show,
          :sideber_menu_groups => sideber_menu_groups,
        })
    end
  end
end
