class ApplicationMailer < ActionMailer::Base
  default from: AppConfig[:admin_email]
  layout "mailer"
end
