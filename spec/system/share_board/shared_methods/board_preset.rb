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
    find(".BoardPresetModal .board_preset_key").select(preset_key)
  end

  def assert_board_preset_selected(preset_key)
    find(".BoardPresetModal .board_preset_key").assert_selector(:select, selected: preset_key)
  end

  def board_preset_arrow_button_click(direction)
    find(".board_preset_step_handle.#{direction}").click
  end
end
