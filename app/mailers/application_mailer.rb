class ApplicationMailer < ActionMailer::Base
  default from: "#{AppConfig[:admin_email_name]} <#{AppConfig[:admin_email]}>"
  default to: AppConfig[:admin_email]

  layout "mailer"

  USELESS_MAIL_ADDRESS_LIST = %w(au.com)
  APP_NAME_APPEND = false

  private

  def subject_prefix
    av = []
    if APP_NAME_APPEND
      av << "[#{AppConfig[:app_name]}]"
    end
    unless Rails.env.production?
      av << "[#{Rails.env}]"
    end
    s = av.join
    if s.present?
      s += " "
    end
    s
  end

  def app_name_prepend(subject)
    [subject_prefix, subject].join
  end

  # 役に立たないメールアドレスか？
  # au.com には容量の大きなファイルを添付すると送れない
  def useless_mail_address?(email)
    address = Mail::Address.new(email)
    USELESS_MAIL_ADDRESS_LIST.include?(address.domain)
  end

  # 必ず最後を改行にしないと添付ファイルが前行の最後のカラムから始まってしまう
  def body_normalize(body)
    body.to_s.rstrip + "\n"
  end

  # 表などが崩れないようにするための固定幅表示
  concerning :FixedFormatMethods do
    included do
      CSS_FONTS = %(Osaka-mono, "Osaka-等幅", "ＭＳ ゴシック", "Courier New", Consolas, monospace)
    end

    private

    def params_normalize_if_fixed(params)
      params = {
        fixed: false,
      }.merge(params)

      if params[:fixed]
        body = gmail_problem_workaround(params[:body])
        params = params.merge(content_type: "text/html", body: pre_tag(body))
      end

      params
    end

    def pre_tag(text)
      %(<pre style='white-space: pre; font-family: #{CSS_FONTS}'>#{text}</pre>)
    end

    # GMailで改行が2重になる対策
    def gmail_problem_workaround(text)
      text.to_s.gsub("\n", "<br>")
    end
  end
end
