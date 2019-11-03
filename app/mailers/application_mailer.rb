class ApplicationMailer < ActionMailer::Base
  cattr_accessor(:measures_against_double_line_feeds_in_gmail) { true } # GMailで改行が2重になる対策

  default from: AppConfig[:admin_email]
  default to: AppConfig[:admin_email]

  layout "mailer"

  # ApplicationMailer.developper_notice.deliver_now
  def developper_notice(**params)
    body = measures_new_line_in_gmail_is_to_double(params[:body].to_s)
    mail(subject: subject_for(params[:subject]), content_type: "text/html", body: monospaced_text(body))
  end

  private

  def subject_prefix
    "[#{AppConfig[:app_name]} #{Rails.env}]" + " "
  end

  def subject_for(str)
    [subject_prefix, " ", str].join
  end

  def monospaced_text(text)
    %(<pre style='white-space: pre; font-family: Osaka-mono, "Osaka-等幅", "ＭＳ ゴシック", "Courier New", Consolas, monospace'>#{text}</pre>)
  end

  def measures_new_line_in_gmail_is_to_double(text)
    if measures_against_double_line_feeds_in_gmail
      text = text.gsub("\n", "<br>")
    end
    text
  end
end
