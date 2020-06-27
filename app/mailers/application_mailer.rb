class ApplicationMailer < ActionMailer::Base
  default from: "#{AppConfig[:admin_email_name]} <#{AppConfig[:admin_email]}>"
  default to: AppConfig[:admin_email]

  layout "mailer"

  # ApplicationMailer.developper_notice.deliver_later
  def developper_notice(params = {})
    mail(fixed_format(subject: subject_for(params[:subject])))
  end

  private

  def subject_prefix
    "[#{AppConfig[:app_name]}][#{Rails.env}]" + " "
  end

  def subject_for(subject)
    [subject_prefix, " ", subject].join
  end

  # 固定幅で表示するための仕組み
  concerning :FixedFormatMethods do
    included do
      CSS_FONTS = %(Osaka-mono, "Osaka-等幅", "ＭＳ ゴシック", "Courier New", Consolas, monospace)
    end

    def fixed_format(params)
      body = measures_new_line_in_gmail_is_to_double(params[:body].to_s)
      params.merge(content_type: "text/html", body: pre_tag(body))
    end

    def pre_tag(text)
      %(<pre style='white-space: pre; font-family: #{CSS_FONTS}'>#{text}</pre>)
    end

    def measures_new_line_in_gmail_is_to_double(text)
      # GMailで改行が2重になる対策
      if true
        text = text.gsub("\n", "<br>")
      end
      text
    end
  end
end
