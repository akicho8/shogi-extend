class ApplicationMailer < ActionMailer::Base
  default from: AppConfig[:admin_email]
  # default to: AppConfig[:admin_email]
  default to: "pinpon.ikeda@gmail.com"
  layout "mailer"

  # ApplicationMailer.user_created.deliver_now
  def user_created(user)
    mail(subject: "【#{AppConfig[:app_name]}】#{user.name}さんが登録されました", body: user.slice(:id, :name).to_t)
  end
end
