module FrontendScript
  class XconvRecordListScript < Base
    self.script_name = "GIF変換キュー"

    def script_body
      XconvRecord.order(id: :desc).limit(100)
    end
  end
end
