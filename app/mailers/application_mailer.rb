class ApplicationMailer < ActionMailer::Base
  default from: Rails.env.production? ? "pinpon.ikeda@gmail.com" : "alice@localhost"
  layout "mailer"
end
