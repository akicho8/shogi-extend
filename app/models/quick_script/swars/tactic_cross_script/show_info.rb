class QuickScript::Swars::TacticCrossScript
  class ShowInfo
    include ApplicationMemoryRecord
    memory_record [
      {
        key: :normal,
        name: "基本",
        el_message: "普通に並べる",
        value_fn: -> attrs { cell_value_variant(attrs) },
      },
      {
        key: :highlight,
        name: "ハイライト",
        el_message: "注目の戦法をもっと目立たせる",
        value_fn: -> attrs { cell_value_variant(attrs, inactive_thin: true) },
      },
      {
        key: :dot,
        name: "ドット",
        el_message: "注目の戦法を●にする",
        value_fn: -> attrs { cell_value_variant(attrs, name: "●", inactive_blank: true) },
      },
      {
        key: :with_score,
        name: "スコア",
        el_message: "頻度か勝率も表示する",
        value_fn: -> attrs {
          r = []
          r << cell_value_variant(attrs)
          r << tag.small("%.*f" % [order_info.float_width, attrs[order_info.order_by]])
          r = v_stack(r)
        },
      },
      {
        key: :debug,
        name: "デバッグ",
        el_message: "詳細を表示する",
        value_fn: -> attrs {
          r = []
          r << cell_value_variant(attrs, inactive_bold: true)
          r << tag.small("段級: #{attrs[:"棋力"]}")
          OrderInfo.each do |e|
            r << tag.small("#{e.order_by}: %.*f" % [e.float_width, attrs[e.order_by]])
          end
          JudgeInfo.each do |e|
            r << tag.small("#{e.short_name}: #{attrs[e.short_name.to_sym]}")
          end
          r << tag.small("出現: #{attrs[:"出現数"]}")
          r = v_stack(r)
        },
      },
    ]
  end
end
