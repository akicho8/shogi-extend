class QuickScript::Swars::CrossSearchScript
  class OpenActionInfo
    include ApplicationMemoryRecord
    memory_record [
      { key: :same_tab, name: "同じタブで開く", redirect_type: :quickly,  },
      { key: :new_tab,  name: "別のタブで開く", redirect_type: :tab_open, },
    ]
  end
end
