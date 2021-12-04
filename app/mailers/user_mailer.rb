class UserMailer < ApplicationMailer
  # 管理者へ通知
  # UserMailer.user_created(User.first).deliver_later
  # http://localhost:3000/rails/mailers/user/user_created
  def user_created(user)
    attrs = {
      :id             => user.id,
      :name           => user.name,
      :email          => user.email,
      :provider_names => user.provider_names,
      :twitter_url    => user.twitter_url,
      :avatar_url     => user.avatar_url,
    }

    body = []
    body << attrs.to_t
    body << user.info.to_t
    body = body.join("\n")
    body = body_normalize(body)

    subject = []
    subject << "#{user.name}さんが#{user.provider_names.join(" or ")}で登録されました"
    subject = subject.join
    subject = app_name_prepend(subject)

    params = { subject: subject, body: body, fixed: true }
    params = params_normalize_if_fixed(params)

    mail(params)
  end

  # 問題の作者に通知
  # UserMailer.question_owner_message(Actb::QuestionMessage.first).deliver_later
  # http://localhost:3000/rails/mailers/actb/question_owner_message
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
      out << UrlProxy.full_url_for("/actb")
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
    subject = []
    subject << EmojiInfo.fetch("棋譜ZIP")
    subject << "[将棋ウォーズ棋譜検索]"
    subject << "#{record.target_user.key}さんの棋譜取得完了"
    subject = subject.join(" ")

    diff_count = other_options[:diff_count] || 0

    body = []
    body << "追加: #{diff_count} 件"
    body << "全体: #{record.zip_dl_scope.count} 件"
    body << ""

    body << "▼#{record.target_user.key}さんの棋譜"
    body << UrlProxy.full_url_for(path: "/swars/search", query: {query: record.target_user_key})
    body << ""

    if record.attachment_mode == "nothing" || Rails.env.development?
      body << "※棋譜を添付するには「ZIPファイルの添付」を有効にしてください"
      body << ""
    end

    body << "--"
    body << "SHOGI-EXTEND"
    body << url_for(:root)

    if Rails.env.development?
      body << record.to_t
      if other_options.present?
        body << other_options.to_t
      end
    end

    body = body.join("\n")
    body = body_normalize(body)

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
end
