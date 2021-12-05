class KiwiMailer < ApplicationMailer
  # 動画作成完了
  # KiwiMailer.lemon_notify(Kiwi::Lemon.last).deliver_later
  # http://localhost:3000/rails/mailers/kiwi/lemon_notify
  def lemon_notify(lemon)
    subject = []
    subject << "動画作成"
    subject << "##{lemon.id}"
    subject << "#{lemon.status_key}"
    subject = subject.join(" ")
    subject = [EmojiInfo.fetch(":動画:"), app_name_prepend(subject)].join

    body = []
    if lemon.browser_url
      if useless_mail_address?(lemon.user.email) || Rails.env.development? || Rails.env.test?
        body << "※ #{lemon.user.email} の管理元があれなのでファイルを添付できませんでした。ちゃんとしたメールアドレスへの変更をおすすめします。"
        body << ""
      end
      if useless_mail_address?(lemon.user.email)
        body << "▼生成ファイル"
      else
        body << "▼生成ファイル (添付してある)"
      end
      body << lemon.browser_url
      body << ""
      body << "▼ライブラリ登録はここ↓から#{lemon.id}番の「↑」ボタンをタップする"
      body << UrlProxy.full_url_for("/video/new")
      body << ""
    end
    body << "▼棋譜の確認または再度動画を作成するにはここ↓の右上メニューから「動画変換」をタップする"
    body << "#{UrlProxy.full_url_for(lemon.recordable.share_board_path)}"
    body << ""
    body << "▼その他"
    body << "登録: #{lemon.created_at&.to_s(:ymdhms)}"
    body << "開始: #{lemon.process_begin_at&.to_s(:ymdhms)}"
    body << "完了: #{lemon.process_end_at&.to_s(:ymdhms)}"
    body << "失敗: #{lemon.error_message}" if lemon.errored_at
    body << ""
    if s = lemon.all_params[:media_builder_params][:cover_text].presence
      body << "▼表紙"
      body << s
      body << ""
    end
    body << "▼元の棋譜"
    body << lemon.recordable.kifu_body
    body << ""
    body << "--"
    body << "動画作成"
    body << UrlProxy.full_url_for("/video/new")

    unless useless_mail_address?(lemon.user.email)
      if lemon.real_path
        if lemon.real_path.exist?
          attachments[lemon.filename_human] = lemon.real_path.read
        end
      end
    end

    if Rails.env.development?
      body << url_for(:root)
      body << lemon.browser_url
      body << lemon.to_t
      if lemon.ffprobe_info
        body << lemon.ffprobe_info[:pretty_format]["streams"][0].to_t
        body << lemon.ffprobe_info[:direct_format]["streams"][0].to_t
      end
    end

    body = body.join("\n")
    body = body_normalize(body)

    mail({
        :subject => subject,
        :to      => "#{lemon.user.name} <#{lemon.user.email}>",
        :bcc     => AppConfig[:admin_email],
        :body    => body,
      })
  end

  # 動画の作者に通知
  # KiwiMailer.banana_owner_message(Kiwi::BananaMessage.first).deliver_later
  # http://localhost:3000/rails/mailers/kiwi/banana_owner_message
  def banana_owner_message(banana_message)
    subject = []
    subject << EmojiInfo.fetch(":コメント:")
    subject << "#{banana_message.user.name}さんが「#{banana_message.banana.title}」にコメントしました"
    subject = subject.join

    out = []
    out << banana_message.unescaped_body
    out << ""
    out << banana_message.banana.page_url

    if Rails.env.test? || Rails.env.development?
      out << ""
      out << "--"
      out << "▼動画"
      out << UrlProxy.full_url_for("/video")
    end

    body = out.join("\n") + "\n"

    user = banana_message.banana.user
    to = "#{user.name} <#{user.email}>"

    mail(subject: subject, body: body, to: to, bcc: AppConfig[:admin_email])
  end

  # 以前コメントした人に通知
  # KiwiMailer.banana_other_message(User.first, Kiwi::BananaMessage.first).deliver_later
  # http://localhost:3000/rails/mailers/kiwi/banana_other_message
  def banana_other_message(user, banana_message)
    subject = []
    subject << EmojiInfo.fetch(":コメント:")
    subject << "以前コメントした「#{banana_message.banana.title}」に#{banana_message.user.name}さんがコメントしました"
    subject = subject.join

    out = []
    out << banana_message.unescaped_body
    out << ""
    out << banana_message.banana.page_url

    body = out.join("\n")

    to = "#{user.name} <#{user.email}>"

    mail(subject: subject, body: body, to: user.email, bcc: AppConfig[:admin_email])
  end
end
