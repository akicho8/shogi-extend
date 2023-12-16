module ShareBoard
  class MessageScopeInfo
    include ApplicationMemoryRecord
    memory_record [
      { key: :ms_public,  name: "全体",     },
      { key: :ms_private, name: "観戦者宛", },
    ]
  end
end
