class UserMailer < ApplicationMailer
  # UserMailer.user_created(User.first).deliver_now
  # http://0.0.0.0:3000/rails/mailers/user/user_created
  def user_created(user)
    attrs = {
      id: user.id,
      name: user.name,
      email: user.email,
    }
    if auth_info = user.auth_infos.first
      provider = auth_info.provider
    else
      provider = "？"
    end

    attrs[:provider] = provider
    attrs[:user_agent] = user.user_agent

    out = []
    out << attrs.to_t
    body = out.join("\n")

    mail(fixed_font(subject: "#{subject_prefix}#{user.name}さんが#{provider}で登録されました", body: body))
  end

  # UserMailer.question_message_created(Actb::QuestionMessage.first).deliver_now
  # http://0.0.0.0:3000/rails/mailers/user/question_message_created
  def question_message_created(message)
    out = []
    out << message.body
    out << message.question.page_url
    out << ""
    out << "--"
    out << "将棋トレーニングバトル"
    out << "https://www.shogi-extend.com/training"
    body = out.join("\n")

    mail(to: message.question.user.email, subject: "「#{message.question.title}」に#{message.user.name}さんからコメントがありました", body: body)
  end
end
