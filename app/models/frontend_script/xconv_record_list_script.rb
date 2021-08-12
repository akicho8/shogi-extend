module FrontendScript
  class XconvRecordListScript < Base
    self.script_name = "アニメーション変換キュー"

    def script_body
      XconvRecord.order(id: :desc).limit(100)
    end
  end
end
