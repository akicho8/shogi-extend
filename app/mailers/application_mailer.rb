class ApplicationMailer < ActionMailer::Base
  default from: AppConfig[:admin_email]
  default to: AppConfig[:admin_email]

  layout "mailer"

  # ApplicationMailer.developper_notice.deliver_now
  def developper_notice(**params)
    mail(subject: [subject_prefix, " ", params[:subject]].join, body: params[:body].to_s)
  end

  private

  def subject_prefix
    "[#{AppConfig[:app_name]} #{Rails.env}] "
  end
end
