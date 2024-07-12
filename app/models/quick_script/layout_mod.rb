module QuickScript
  concern :LayoutMod do
    prepended do
      class_attribute :navibar_show, default: true # MainNavbar を表示する？
    end

    def as_json(*)
      super.merge({
          :navibar_show                  => navibar_show,
        })
    end
  end
end
