module SharedMethods
  def board_preset_select_from_menu(preset_key)
    board_preset_select(preset_key)
    board_preset_apply
  end

  def board_preset_apply
    find(".board_preset_apply_handle").click
  end

  def board_preset_close
    find(".board_preset_modal_close_handle").click
  end

  def board_preset_select(preset_key)
    find(".board_preset_dropdown button").click
    find(".board_preset_dropdown .dropdown-item", text: preset_key, exact_text: true).click
  end

  def assert_board_preset_selected(preset_key)
    assert_selector(".board_preset_dropdown button", text: preset_key, exact_text: true)
  end

  def board_preset_arrow_button_click(direction)
    find(".board_preset_arrow_handle .#{direction}").click
  end
end
