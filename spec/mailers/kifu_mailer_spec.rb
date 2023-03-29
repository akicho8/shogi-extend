require "rails_helper"

RSpec.describe KifuMailer, type: :mailer do
  it "works" do
    mail = KifuMailer.basic_mail(KifuMailAdapter.mock_params)
    assert2 { mail.text_part.decoded.match?(/▼再生/) }
    assert2 { mail.attachments.count == 1 }
    assert2 { mail.bcc == ["shogi.extend@gmail.com"] }
  end
end
