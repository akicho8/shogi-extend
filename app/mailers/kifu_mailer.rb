class KifuMailer < ApplicationMailer
  # 棋譜作成完了
  # http://localhost:3000/rails/mailers/kifu/basic_mail
  def basic_mail(params)
    adapter = KifuMailAdapter.new(params)

    subject = []
    subject += adapter.subject
    subject = subject.join(" ")
    subject = [EmojiInfo.fetch(":棋譜:"), app_name_prepend(subject)].join

    body = []
    body += adapter.body

    body << "--"
    body << "共有将棋盤"
    body << UrlProxy.full_url_for("/share-board")

    if Rails.env.development?
      body << url_for(:root)
      body << params.to_t
    end

    body = body.join("\n")
    body = body_normalize(body)

    attachments[adapter.attachment_filename] = adapter.kifu_parser.to_kif

    mail({
        :subject => subject,
        :to      => "#{params[:user].name} <#{params[:user].email}>",
        :bcc     => AppConfig[:admin_email],
        :body    => body,
      })
  end

  # # 棋譜の作者に通知
  # # KifuMailer.banana_owner_message(Kifu::BananaMessage.first).deliver_later
  # # http://localhost:3000/rails/mailers/kiwi/banana_owner_message
  # def banana_owner_message(banana_message)
  #   subject = []
  #   subject << EmojiInfo.fetch(":コメント:")
  #   subject << "#{banana_message.user.name}さんが「#{banana_message.banana.title}」にコメントしました"
  #   subject = subject.join
  #
  #   out = []
  #   out << banana_message.unescaped_body
  #   out << ""
  #   out << banana_message.banana.page_url
  #
  #   if Rails.env.test? || Rails.env.development?
  #     out << ""
  #     out << "--"
  #     out << "▼棋譜"
  #     out << UrlProxy.full_url_for("/video")
  #   end
  #
  #   body = out.join("\n") + "\n"
  #
  #   user = banana_message.banana.user
  #   to = "#{user.name} <#{user.email}>"
  #
  #   mail(subject: subject, body: body, to: to, bcc: AppConfig[:admin_email])
  # end
  #
  # # 以前コメントした人に通知
  # # KifuMailer.banana_other_message(User.first, Kifu::BananaMessage.first).deliver_later
  # # http://localhost:3000/rails/mailers/kiwi/banana_other_message
  # def banana_other_message(user, banana_message)
  #   subject = []
  #   subject << EmojiInfo.fetch(":コメント:")
  #   subject << "以前コメントした「#{banana_message.banana.title}」に#{banana_message.user.name}さんがコメントしました"
  #   subject = subject.join
  #
  #   out = []
  #   out << banana_message.unescaped_body
  #   out << ""
  #   out << banana_message.banana.page_url
  #
  #   body = out.join("\n")
  #
  #   to = "#{user.name} <#{user.email}>"
  #
  #   mail(subject: subject, body: body, to: user.email, bcc: AppConfig[:admin_email])
  # end
end
