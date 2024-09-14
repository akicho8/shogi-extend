class QuickScript::Swars::CrossSearchScript
  class DownloadInfo
    include ApplicationMemoryRecord
    memory_record [
      { key: :off, name: "しない", },
      { key: :on,  name: "する",   },
    ]
  end
end
