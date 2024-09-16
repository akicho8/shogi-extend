class QuickScript::Swars::CrossSearchScript
  class NewTabInfo
    include ApplicationMemoryRecord
    memory_record [
      { key: :off, name: "OFF", redirect_type: :quickly,  },
      { key: :on,  name: "ON",  redirect_type: :tab_open, },
    ]
  end
end
