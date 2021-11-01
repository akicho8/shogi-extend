current_records.collect {|e|
  row = {
    "id" => link_to(e.id, [ns_prefix, e]),
  }
  row = row.merge(e.attributes.except("id"))
  row = row.merge({
      "操作" => [
        link_to("詳細", [ns_prefix, e]),
        link_to("編集", [:edit, ns_prefix, e]),
        (controller.respond_to_destroy? ? link_to("削除", [ns_prefix, e], method: :delete, data: {confirm: "本当に削除してもよいか？"}) : nil),
      ].compact.join(" ").html_safe,
    })
}.to_html
