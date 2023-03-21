require "rails_helper"

RSpec.describe KiwiMailer, type: :mailer do
  include KiwiSupport

  it "成功したので添付ファイルがある" do
    lemon1.main_process
    mail = KiwiMailer.lemon_notify(lemon1)
    is_asserted_by { mail.attachments.first.mime_type == "application/mp4" }
    is_asserted_by { mail.attachments.first.filename.match?(/mp4/) }
  end

  it "成功してもクソザコメールアドレス宛には添付しない" do
    lemon1.main_process
    lemon1.user.email = "xxx@au.com"
    mail = KiwiMailer.lemon_notify(lemon1)
    is_asserted_by { mail.attachments == [] }
  end

  it "失敗したのでいろいろない" do
    lemon1.all_params[:raise_message] = "bomb"
    lemon1.main_process
    mail = KiwiMailer.lemon_notify(lemon1)
    is_asserted_by { mail.body.decoded.match?(/失敗: bomb/) }
    is_asserted_by { mail.attachments == [] }
  end
end
