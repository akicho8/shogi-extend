class ApplicationMailer < ActionMailer::Base
  default from: "#{AppConfig[:admin_email_name]} <#{AppConfig[:admin_email]}>"
  default to: AppConfig[:admin_email]

  layout "mailer"

  # まともにファイルが添付できないドメイン
  USELESS_MAIL_ADDRESS_LIST = [
    "au.com",
    "ezweb.ne.jp",
    "docomo.ne.jp",
  ]

  APP_NAME_APPEND = false

  private

  def subject_prefix
    av = []
    if APP_NAME_APPEND
      av << "[#{AppConfig[:app_name]}]"
    end
    if !Rails.env.production?
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
        :table_format   => false,
        :fixed          => false,
        :eob_auto_enter => true,
      }.merge(params)

      if params[:table_format]
        if params[:body].kind_of?(Array) || params[:body].kind_of?(Hash)
          params[:body] = params[:body].to_t
        end
      end

      if params[:fixed]
        params[:body] = pre_tag(gmail_problem_workaround(params[:body]))
        params[:content_type] = "text/html"
      end

      if params[:eob_auto_enter]
        params[:body] = eob_auto_enter(params[:body])
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

    # 添付ファイルの位置がずれるのを防ぐために必ず改行を入れる
    def eob_auto_enter(text)
      text.to_s.rstrip + "\n"
    end
  end
end
