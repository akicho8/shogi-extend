require "rails_helper"

RSpec.describe KifuMailer, type: :mailer do
  it "works" do
    mail = KifuMailer.basic_mail(KifuMailAdapter.mock_params)
    assert { mail.text_part.decoded.match?(/▼再生/) }
    assert { mail.attachments.count == 1 }
    assert { mail.bcc.blank? }
  end
end
