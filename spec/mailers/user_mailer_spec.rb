# UserMailer のテストは動くのがあたりまえなので意味がない
# UserMailer を使うモデルでテストする

require "rails_helper"

RSpec.describe UserMailer, type: :mailer do
  describe "user_created" do
    let(:user1) { User.create! }

    it "works" do
      assert2 { UserMailer.user_created(user1) }
    end
  end
end
