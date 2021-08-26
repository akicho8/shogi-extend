module FrontendScript
  class XmovieRecordListScript < Base
    self.script_name = "動画生成キュー"

    def script_body
      XmovieRecord.order(id: :desc).limit(100)
    end
  end
end
