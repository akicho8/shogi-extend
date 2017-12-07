current_records.collect {|e|
  row = {
    "id" => link_to(e.id, [:resource_ns1, e]),
  }
  row = row.merge(e.attributes.except("id"))
  row = row.merge({
      "操作" => [
        link_to("詳細", [:resource_ns1, e]),
        link_to("編集", [:edit, :resource_ns1, e]),
        (controller.respond_to_destroy? ? link_to("削除", [:resource_ns1, e], method: :delete, data: {confirm: "本当に削除してもよろしいですか？"}) : nil),
      ].compact.join(" ").html_safe,
    })
}.to_html
