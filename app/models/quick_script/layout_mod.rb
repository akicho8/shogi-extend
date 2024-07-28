module QuickScript
  concern :LayoutMod do
    prepended do
      class_attribute :main_component, default: { _component: "QuickScriptViewDefault" } # ビューの種類 (nil で表示しない)
      class_attribute :navibar_show,    default: true   # MainNavbar を表示する？
      class_attribute :container_width, default: :large # 画面幅 (small: 狭い, large: 広い)
      class_attribute :body_position,   default: :below # 結果の位置 (above: 上, below: 下)
    end

    def as_json(*)
      super.merge({
          :main_component  => main_component,
          :navibar_show    => navibar_show,
          :container_width => container_width,
          :body_position   => body_position,
        })
    end
  end
end
