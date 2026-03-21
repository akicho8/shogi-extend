module SharedMethods
  def assert_var(key, value, **options)
    assert_selector(".assert_var .panel-block", text: "#{key}:#{value}", exact_text: true, **options)
  end

  def assert_no_var(key, value, **options)
    assert_no_selector(".assert_var .panel-block", text: "#{key}:#{value}", exact_text: true, **options)
  end

  def room_recreate_apply
    sidebar_open
    find(".room_recreate_modal_open_handle").click
    first(".apply_button").click
  end

  def buefy_dialog_button_click(type = "")
    find(".modal button#{type}").click
  end

  def kifu_read_run
    sidebar_open
    find(".kifu_loader_modal_open_handle").click
    find(".KifuLoaderModal textarea").set("68S", clear: :backspace)
    find(".KifuLoaderModal .submit_handle").click
  end
end
