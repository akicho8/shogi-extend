class ApplicationMailer < ActionMailer::Base
  default from: "#{AppConfig[:admin_email_name]} <#{AppConfig[:admin_email]}>"
  default to: AppConfig[:admin_email]

  layout "mailer"
end
