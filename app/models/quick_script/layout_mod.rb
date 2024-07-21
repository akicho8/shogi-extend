module QuickScript
  concern :LayoutMod do
    prepended do
      class_attribute :navibar_show, default: true    # MainNavbar を表示する？
      class_attribute :layout_size,  default: :large  # 画面幅 (small: 狭い, large: 広い)
    end

    def as_json(*)
      super.merge({
          :navibar_show => navibar_show,
          :layout_size  => layout_size,
        })
    end
  end
end
