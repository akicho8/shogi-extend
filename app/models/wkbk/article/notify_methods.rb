module Wkbk
  class Article
    concern :NotifyMethods do
      def notify
        AppLog.important(emoji: ":問題:", subject: mail_subject, body: mail_body)
      end

      def status_name
        if created_at == updated_at
          "作成"
        else
          "更新"
        end
      end

      # rails r 'puts Wkbk::Article.first.mail_subject'
      def mail_subject
        av = []
        av << "[将棋ドリル]"
        av << "問題#{status_name}"
        av << "##{id}"
        av << title
        av << user.name
        av << "計#{user.wkbk_articles.count}回"
        av.join(" ").squish
      end

      # rails r 'puts Wkbk::Article.first.mail_body'
      def mail_body
        {
          "ブラウザURL"  => page_url(force: true),
          "共有将棋盤"   => share_board_url,
          "所属問題集"   => mail_belongs_books.to_t,
          "属性"         => info.to_t,
          "棋譜"         => to_kif,
        }.collect { |k, v| "▼#{k}\n#{v}".strip }.join("\n\n")
      end

      # rails r 'puts Wkbk::Article.first.mail_body'
      def mail_belongs_books
        books.collect do |e|
          {
            "タイトル" => e.title,
            "URL" => e.page_url(force: true),
          }
        end
      end
    end
  end
end
