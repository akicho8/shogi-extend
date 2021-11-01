module FrontendScript
  class KiwiRecordListScript < Base
    self.script_name = "動画作成キュー"

    def script_body
      Kiwi::Lemon.order(id: :desc).limit(100)
    end
  end
end
