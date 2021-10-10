class KiwiMailer < ApplicationMailer
  # 動画作成完了
  # KiwiMailer.lemon_notify(Kiwi::Lemon.last).deliver_later
  # http://localhost:3000/rails/mailers/user/lemon_notify
  def lemon_notify(lemon)
    # 本文
    body = []
    body << "登録: #{lemon.created_at&.to_s(:ymdhms)}"
    body << "開始: #{lemon.process_begin_at&.to_s(:ymdhms)}"
    body << "完了: #{lemon.process_end_at&.to_s(:ymdhms)}"
    body << "失敗: #{lemon.error_message}" if lemon.errored_at
    body << "棋譜: #{UrlProxy.full_url_for(lemon.recordable.share_board_path)}"
    body << ""
    body << "--"
    body << "SHOGI-EXTEND"
    body << url_for(:root)

    if Rails.env.development?
      body << lemon.browser_url
      body << lemon.to_t
      if lemon.ffprobe_info
        body << lemon.ffprobe_info[:pretty_format]["streams"][0].to_t
        body << lemon.ffprobe_info[:direct_format]["streams"][0].to_t
      end
    end

    # 添付
    media_builder = lemon.media_builder
    if media_builder.file_exist?
      attachments[lemon.filename_human] = media_builder.real_path.read
    end

    mail({
        subject: "【動画作成】[#{lemon.id}] #{lemon.recipe_info.name} 生成#{lemon.status_key}",
        to: "#{lemon.user.name} <#{lemon.user.email}>",
        bcc: AppConfig[:admin_email],
        body: body.join("\n") + "\n", # NOTE: 最後を改行にしないと添付ファイルが前行の最後のカラムから始まってしまう
      })
  end

  # 動画の作者に通知
  # KiwiMailer.banana_owner_message(Kiwi::BananaMessage.first).deliver_later
  # http://localhost:3000/rails/mailers/user/banana_owner_message
  def banana_owner_message(banana_message)
    subject = "#{banana_message.user.name}さんが「#{banana_message.banana.title}」にコメントしました"

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

    mail(subject: subject, to: banana_message.banana.user.email, bcc: AppConfig[:admin_email], body: body)
  end

  # 以前コメントした人に通知
  # KiwiMailer.banana_other_message(User.first, Kiwi::BananaMessage.first).deliver_later
  # http://localhost:3000/rails/mailers/user/banana_other_message
  def banana_other_message(user, banana_message)
    subject = "以前コメントした「#{banana_message.banana.title}」に#{banana_message.user.name}さんがコメントしました"

    out = []
    out << banana_message.unescaped_body
    out << ""
    out << banana_message.banana.page_url

    body = out.join("\n")

    mail(subject: subject, to: user.email, bcc: AppConfig[:admin_email], body: body)
  end
end
