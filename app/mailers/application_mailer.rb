class ApplicationMailer < ActionMailer::Base
  MEASURES_AGAINST_DOUBLE_LINE_FEEDS_IN_GMAIL = true # GMailで改行が2重になる対策

  default from: AppConfig[:admin_email]
  default to: AppConfig[:admin_email]

  layout "mailer"

  # ApplicationMailer.developper_notice.deliver_now
  def developper_notice(**params)
    pre_body = params[:body].to_s
    if MEASURES_AGAINST_DOUBLE_LINE_FEEDS_IN_GMAIL
      pre_body = pre_body.gsub("\n", "<br>")
    end
    mail(subject: [subject_prefix, " ", params[:subject]].join, content_type: "text/html", body: "<pre style='white-space: pre; font-family: Osaka-mono, \"Osaka-等幅\", \"ＭＳ ゴシック\", \"Courier New\", Consolas, monospace'>#{pre_body}</pre>")
  end

  private

  def subject_prefix
    "[#{AppConfig[:app_name]} #{Rails.env}] "
  end
end
