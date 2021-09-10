class UserMailer < ApplicationMailer
  # 管理者へ通知
  # UserMailer.user_created(User.first).deliver_later
  # http://localhost:3000/rails/mailers/user/user_created
  def user_created(user)
    attrs = {
      :id    => user.id,
      :name  => user.name,
      :email => user.email,
    }

    attrs[:provider_names] = user.provider_names
    attrs[:twitter_url] = user.twitter_url
    attrs[:avatar_url] = user.avatar_url

    out = []
    out << attrs.collect { |key, val| "#{key}: #{val}" }
    body = out.join("\n")

    mail(subject: subject_decorate("#{user.name}さんが#{user.provider_names.join(" or ")}で登録されました"), body: body)
  end

  # 問題の作者に通知
  # UserMailer.question_owner_message(Actb::QuestionMessage.first).deliver_later
  # http://localhost:3000/rails/mailers/user/question_owner_message
  def question_owner_message(message)
    subject = "#{message.user.name}さんが「#{message.question.title}」にコメントしました"

    out = []
    out << message.unescaped_body
    out << ""
    out << message.question.page_url

    if Rails.env.test? || Rails.env.development?
      out << ""
      out << "--"
      out << "▼将棋トレーニングバトル"
      out << UrlProxy.wrap2("/actb")
    end

    body = out.join("\n")

    mail(subject: subject, to: message.question.user.email, bcc: AppConfig[:admin_email], body: body)
  end

  # 以前コメントした人に通知
  # UserMailer.question_other_message(User.first, Actb::QuestionMessage.first).deliver_later
  # http://localhost:3000/rails/mailers/user/question_other_message
  def question_other_message(user, message)
    subject = "以前コメントした「#{message.question.title}」に#{message.user.name}さんがコメントしました"

    out = []
    out << message.unescaped_body
    out << ""
    out << message.question.page_url

    body = out.join("\n")

    mail(subject: subject, to: user.email, bcc: AppConfig[:admin_email], body: body)
  end

  # 棋譜取得完了
  # UserMailer.battle_fetch_notify(Swars::CrawlReservation.first).deliver_later
  # http://localhost:3000/rails/mailers/user/battle_fetch_notify
  def battle_fetch_notify(record, other_options = {})
    subject_suffix = ""

    if Rails.env.development?
      if record.attachment_mode == "with_zip"
        subject_suffix = "(添付あり)"
      end
    end

    subject = "【将棋ウォーズ棋譜検索】#{record.target_user.key}さんの棋譜取得完了 #{subject_suffix}".squish

    diff_count = other_options[:diff_count] || 0

    out = []
    out << "追加: #{diff_count} 件"
    out << "全体: #{record.zip_dl_scope.count} 件"
    out << ""

    out << "#{record.target_user.key}さんの棋譜"
    out << UrlProxy.wrap2(path: "/swars/search", query: {query: record.target_user_key})

    out << ""
    out << "--"
    out << "SHOGI-EXTEND"
    out << url_for(:root)
    if Rails.env.development?
      out << record.to_t
      if other_options.present?
        out << other_options.to_t
      end
    end

    body = out.join("\n")

    user = record.user

    if user.email == record.to_email
      to = "#{user.name} <#{user.email}>"
    else
      to = record.to_email
    end

    if record.attachment_mode == "with_zip"
      attachments[record.zip_filename] = record.to_zip.string
    end

    mail(subject: subject, to: to, bcc: AppConfig[:admin_email], body: body)
  end

  # 動画生成完了
  # UserMailer.xmovie_notify(XmovieRecord.last).deliver_later
  # http://localhost:3000/rails/mailers/user/xmovie_notify
  def xmovie_notify(xmovie_record)
    # 本文
    body = []
    body << "登録: #{xmovie_record.created_at&.to_s(:ymdhms)}"
    body << "開始: #{xmovie_record.process_begin_at&.to_s(:ymdhms)}"
    body << "完了: #{xmovie_record.process_end_at&.to_s(:ymdhms)}"
    body << "失敗: #{xmovie_record.error_message}" if xmovie_record.errored_at
    body << "棋譜: #{UrlProxy.wrap2(xmovie_record.recordable.share_board_path)}"
    body << ""
    body << "--"
    body << "SHOGI-EXTEND"
    body << url_for(:root)

    if Rails.env.development?
      body << xmovie_record.browser_url
      body << xmovie_record.to_t
      if xmovie_record.ffprobe_info
        body << xmovie_record.ffprobe_info[:pretty_format]["streams"][0].to_t
        body << xmovie_record.ffprobe_info[:direct_format]["streams"][0].to_t
      end
    end

    # 添付
    generator = xmovie_record.generator
    if generator.file_exist?
      attachments[xmovie_record.filename_human] = generator.real_path.read
    end

    mail({
        subject: "【動画生成】[#{xmovie_record.id}] #{xmovie_record.recipe_info.name} 生成#{xmovie_record.status_key}",
        to: "#{xmovie_record.user.name} <#{xmovie_record.user.email}>",
        bcc: AppConfig[:admin_email],
        body: body.join("\n") + "\n", # NOTE: 最後を改行にしないと添付ファイルが前行の最後のカラムから始まってしまう
      })
  end
end
