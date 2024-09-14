class QuickScript::Swars::CrossSearchScript
  class EncodeInfo
    include ApplicationMemoryRecord
    memory_record [
      { key: :"UTF-8",     transform_method: :itself, },
      { key: :"Shift_JIS", transform_method: :tosjis, },
    ]
  end
end
