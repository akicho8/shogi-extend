module Kiwi
  class BookMessage < ApplicationRecord
    include MessageShared

    belongs_to :book, counter_cache: true

    after_create_commit do
      Kiwi::BookMessageBroadcastJob.perform_later(self)

      # 作者に通知
      if true
        if book.user != user
          if book.user.email_valid? || Rails.env.test?
            KiwiMailer.book_owner_message(self).deliver_later
          end
          # book.user.notifications.create!(book_message: self)
        end
      end

      # 以前コメントした人たちにも通知
      if true
        member_users.each do |user|
          if user.email_valid? || Rails.env.test?
            KiwiMailer.book_other_message(user, self).deliver_later
          end
          # user.notifications.create!(book_message: self)
        end
      end

      SlackAgent.message_send(key: "問題コメント", body: [body, book.page_url].join("\n"))
    end

    # 関係者
    def member_users
      users = book.book_message_users         # コメントした人たち
      users = users - [user]                 # コメントした本人はコメント内容を知っているので送信しない
      users = users - [book.user]        # 作者にはすでに送っているので送信しない
      users = users.uniq                     # 複数通知しないように
    end
  end
end
