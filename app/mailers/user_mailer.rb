class UserMailer < ApplicationMailer
  # 管理者へ通知
  # UserMailer.user_created(User.first).deliver_later
  # http://0.0.0.0:3000/rails/mailers/user/user_created
  def user_created(user)
    attrs = {
      :id    => user.id,
      :name  => user.name,
      :email => user.email,
    }

    attrs[:provider_names] = user.provider_names
    attrs[:ua_info] = user.ua_info
    attrs[:twitter_url] = user.twitter_url
    attrs[:avatar_url] = user.avatar_url

    out = []
    out << attrs.collect { |key, val| "#{key}: #{val}" }
    body = out.join("\n")

    mail(subject: subject_decorate("#{user.name}さんが#{user.provider_names.join(" or ")}で登録されました"), body: body)
  end

  # 問題の作者に通知
  # UserMailer.question_owner_message(Actb::QuestionMessage.first).deliver_later
  # http://0.0.0.0:3000/rails/mailers/user/question_owner_message
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
      out << url_for(:training)
    end

    body = out.join("\n")

    mail(subject: subject, to: message.question.user.email, bcc: AppConfig[:admin_email], body: body)
  end

  # 以前コメントした人に通知
  # UserMailer.question_other_message(User.first, Actb::QuestionMessage.first).deliver_later
  # http://0.0.0.0:3000/rails/mailers/user/question_other_message
  def question_other_message(user, message)
    subject = "以前コメントした「#{message.question.title}」に#{message.user.name}さんがコメントしました"

    out = []
    out << message.unescaped_body
    out << ""
    out << message.question.page_url

    body = out.join("\n")

    mail(subject: subject, to: user.email, bcc: AppConfig[:admin_email], body: body)
  end

  # 以前コメントした人に通知
  # UserMailer.battle_fetch_notify(Swars::CrawlReservation.first).deliver_later
  # http://0.0.0.0:3000/rails/mailers/user/battle_fetch_notify
  def battle_fetch_notify(record)
    subject = "棋譜取得完了"

    out = []
    out << "#{record.target_user_key}さんの棋譜"
    out << UrlProxy[path: "/swars/search", query: {query: record.target_user_key}]

    out << ""
    out << "--"
    out << "SHOGI-EXTEND"
    out << url_for(:root)
    if Rails.env.development?
      out << record.to_t
    end

    body = out.join("\n")

    user = record.user

    if user.email == record.to_email
      to = "#{user.name} <#{user.email}>"
    else
      to = record.to_email
    end

    if record.attachment_mode == "with_zip"
      attachments[record.zip_filename] = record.zip_binary
    end

    mail(subject: subject, to: to, bcc: AppConfig[:admin_email], body: body)
  end
end
