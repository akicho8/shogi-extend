module Kiwi
  class Book
    concern :InfoMethods do
      def info
        {
          "動画ID"       => id,
          "動画KEY"      => key,
          "動画タイトル" => title,
          "動画投稿者"   => user.name,
          "動画URL"      => page_url,
          "動画公開設定" => folder.name,
          "動画作成日時" => created_at.to_s(:ymdhm),
          "動画説明"     => description.presence.to_s.squish,
        }
      end
    end
  end
end
