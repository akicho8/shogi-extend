class ApplicationMailer < ActionMailer::Base
  default from: AppConfig[:admin_email]
  default to: AppConfig[:admin_email]

  layout "mailer"

  private

  def subject_prefix
    "[#{AppConfig[:app_name]} #{Rails.env}] "
  end
end
