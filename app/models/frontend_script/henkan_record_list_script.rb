module FrontendScript
  class HenkanRecordListScript < Base
    self.script_name = "GIF変換キュー"

    def script_body
      HenkanRecord.order(id: :desc).limit(100)
    end
  end
end
