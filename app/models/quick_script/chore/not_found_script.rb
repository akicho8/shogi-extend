module QuickScript
  module Chore
    class NotFoundScript < Base
      self.title = "Not Found"
      self.description = "ページが見つかりません"
      self.status_code = 404
    end
  end
end
