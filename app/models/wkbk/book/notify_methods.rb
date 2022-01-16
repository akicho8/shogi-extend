module Wkbk
  class Book
    concern :NotifyMethods do
      # rails r 'Wkbk::Book.first.notify'
      def notify
        SystemMailer.notify(fixed: true, emoji: ":問題集:", subject: mail_subject, body: mail_body).deliver_later
      end

      def status_name
        if created_at == updated_at
          "作成"
        else
          "更新"
        end
      end

      # rails r 'puts Wkbk::Book.first.mail_subject'
      def mail_subject
        av = []
        av << "問題集"
        av << "##{id}"
        av << title
        av << user.name
        av << "#{user.wkbk_books.count}つ目"
        av << status_name
        av.join(" ")
      end

      # rails r 'puts Wkbk::Book.first.mail_body'
      def mail_body
        {
          "ブラウザURL" => page_url(force: true),
          "問題集数"    => articles.count,
          "属性"        => info.to_t,
        }.collect { |k, v| "▼#{k}\n#{v}".strip }.join("\n\n")
      end
    end
  end
end
