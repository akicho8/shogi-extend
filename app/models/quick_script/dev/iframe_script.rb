module QuickScript
  module Dev
    class IframeScript < Base
      self.title = "iframe 表示"
      self.description = "iframe タグで別の画面を表示する"

      # http://localhost:4000/lab/dev/iframe
      def call
        h_stack [
          %(<iframe width="480" height="800" src="/lab/swars/hourly-active-user.html" frameborder="0"></iframe>),
          %(<iframe width="480" height="800" src="/lab/swars/hourly-active-user.html" frameborder="0"></iframe>),
        ]
      end
    end
  end
end
