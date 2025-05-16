module QuickScript
  module Dev
    class YoutubeIframeScript < Base
      self.title = "YouTube の iframe タグ"
      self.description = "YouTube の画面を埋め込む"

      def call
        %(<iframe width="1190" height="669" src="https://www.youtube.com/embed/yz4bPL9hl8M" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture" allowfullscreen> </iframe>)
      end
    end
  end
end
