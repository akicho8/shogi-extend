module Wkbk
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
          "出題順序" => sequence.pure_info.name,
          "作成日時" => created_at.to_s(:ymdhm),
          "説明"     => description.presence.to_s.squish,
        }
      end

      def kif_header
        @kif_header ||= info.collect { |k, v| "問題集#{k}：#{v}\n" }.join
      end
    end
  end
end
