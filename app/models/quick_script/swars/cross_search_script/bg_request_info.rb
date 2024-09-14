class QuickScript::Swars::CrossSearchScript
  class BgRequestInfo
    include ApplicationMemoryRecord
    memory_record [
      { key: :off, name: "しない", el_message: "リアルタイムで結果を得る",     },
      { key: :on,  name: "する",   el_message: "あとで結果をメールで受け取る", },
    ]
  end
end
