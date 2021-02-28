class ApplicationMailer < ActionMailer::Base
  default from: "#{AppConfig[:admin_email_name]} <#{AppConfig[:admin_email]}>"
  default to: AppConfig[:admin_email]

  layout "mailer"

  def subject_prefix
    parts = []
    parts << "[#{AppConfig[:app_name]}]"
    unless Rails.env.production?
      parts << "[#{Rails.env}]"
    end
    parts.join + " "
  end

  def subject_decorate(subject)
    [subject_prefix, subject].join
  end
end
