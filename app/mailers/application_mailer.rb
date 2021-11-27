class ApplicationMailer < ActionMailer::Base
  default from: "#{AppConfig[:admin_email_name]} <#{AppConfig[:admin_email]}>"
  default to: AppConfig[:admin_email]

  layout "mailer"

  USELESS_MAIL_ADDRESS_LIST = %w(au.com)

  private

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

  # 役に立たないメールアドレスか？
  # au.com には容量の大きなファイルを添付すると送れない
  def useless_mail_address?(email)
    address = Mail::Address.new(email)
    USELESS_MAIL_ADDRESS_LIST.include?(address.domain)
  end
end
