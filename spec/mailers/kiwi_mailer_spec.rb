require "rails_helper"

RSpec.describe KiwiMailer, type: :mailer do
  include KiwiSupport

  it "添付ファイルがある" do
    lemon1.main_process
    mail = KiwiMailer.lemon_notify(lemon1)
    assert { mail.attachments.first.mime_type == "application/mp4" }
    assert { mail.attachments.first.filename.match?(/mp4/) }
  end
end
