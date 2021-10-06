module Kiwi
  class Book
    concern :InfoMethods do
      def info
        {
          "ID"       => id,
          "KEY"      => key,
          "タイトル" => title,
          "投稿者"   => user.name,
          "URL"      => page_url,
          "公開設定" => folder.name,
          "作成日時" => created_at.to_s(:distance),
          "更新日時" => updated_at.to_s(:ymdhm),
          "説明"     => description.presence.to_s.squish,
        }
      end
    end
  end
end
