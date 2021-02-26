module Wkbk
  class Book
    concern :InfoMethods do
      def info
        {
          "問題集ID"       => id,
          "問題集KEY"      => key,
          "問題集タイトル" => title,
          "問題集投稿者"   => user.name,
          "問題集URL"      => page_url,
          "問題集公開設定" => folder.name,
          "問題集出題順序" => sequence.pure_info.name,
          "問題集作成日時" => created_at.to_s(:ymdhm),
          "問題集説明"     => description.presence.to_s.squish,
        }
      end

      def kif_header
        @kif_header ||= info.collect { |k, v| "#{k}：#{v}\n" }.join
      end
    end
  end
end
