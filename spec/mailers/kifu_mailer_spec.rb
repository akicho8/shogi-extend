require "rails_helper"

RSpec.describe KifuMailer, type: :mailer do
  it "works" do
    mail = KifuMailer.basic_mail(KifuMailAdapter.mock_params)
    is_asserted_by { mail.text_part.decoded.match?(/▼再生/) }
    is_asserted_by { mail.attachments.count == 1 }
    is_asserted_by { mail.bcc == ["shogi.extend@gmail.com"] }
  end
end
