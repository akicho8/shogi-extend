module QuickScript
  module Dev
    class AbstractScript < Base
      self.title = "一覧に出てこない"
      self.description = "abstract_script = true にしてあるため all から除外されている"
      self.abstract_script = true
    end
  end
end
