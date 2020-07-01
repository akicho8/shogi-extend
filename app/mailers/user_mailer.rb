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

    attrs[:provider] = user.provider_name
    attrs[:user_agent] = user.user_agent

    out = []
    out << attrs.to_t
    body = out.join("\n")

    mail(fixed_format(subject: subject_decorate("#{user.name}さんが#{user.provider_name}で登録されました"), body: body))
  end

  # 問題の作者に通知
  # UserMailer.question_message_created(Actb::QuestionMessage.first).deliver_later
  # http://0.0.0.0:3000/rails/mailers/user/question_message_created
  def question_message_created(message)
    subject = "#{message.user.name}さんが「#{message.question.title}」にコメントしました"

    out = []
    out << message.body
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
end
