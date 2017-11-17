class ApplicationMailer < ActionMailer::Base
  default from: Rails.env.production? ? "pinpon.ikeda@gmail.com" : "alice@localhost"
  # default from: "pinpon.ikeda@gmail.com"
  layout "mailer"
end
