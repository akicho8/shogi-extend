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
        el_message: "対象の値も表示する",
        value_fn: -> attrs {
          v = []
          v << cell_value_variant(attrs)
          v << tag.small("%.*f" % [order_info.float_width, attrs[order_info.attr_key]])
          v = v_stack(v)
        },
      },
      {
        key: :debug,
        name: "デバッグ",
        el_message: "詳細を表示する",
        value_fn: -> attrs {
          v = []
          v << cell_value_variant(attrs, inactive_bold: true)
          v << tag.small("段級: #{attrs[:"棋力"]}")
          OrderInfo.each do |e|
            v << tag.small("#{e.attr_key}: %.*f" % [e.float_width, attrs[e.attr_key]])
          end
          JudgeInfo.each do |e|
            v << tag.small("#{e.short_name}: #{attrs[e.short_name.to_sym]}")
          end
          v << tag.small("使用人数: #{attrs[:"使用人数"]}")
          v << tag.small("出現回数: #{attrs[:"出現回数"]}")
          v = v_stack(v)
        },
      },
    ]
  end
end
