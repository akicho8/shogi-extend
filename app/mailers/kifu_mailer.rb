class KifuMailer < ApplicationMailer
  # http://localhost:3000/rails/mailers/kifu/basic_mail
  def basic_mail(params)
    adapter = KifuMailAdapter.new(params)

    subject = [
      EmojiInfo.fetch(adapter.main_icon),
      subject_decorate(adapter.subject),
    ].join

    body = []
    body << adapter.body
    body << ""
    body << "--"
    body << "共有将棋盤"
    body << UrlProxy.full_url_for("/share-board")

    if Rails.env.development?
      body << params.to_t
    end

    body = body.join("\n")
    body = body_normalize(body)

    attachments[adapter.attachment_filename] = adapter.attachment_body

    mail({
        :subject => subject,
        :to      => adapter.mail_to_address,
        :bcc     => nil,        # AppConfig[:admin_email]
        :body    => body,
      })
  end
end
