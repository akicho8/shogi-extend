# UserMailer のテストは動くのがあたりまえなので意味がない
# UserMailer を使うモデルでテストする

require "rails_helper"

RSpec.describe UserMailer, type: :mailer do
  describe "user_created" do
    it "works" do
      assert { UserMailer.user_created(user1) }
    end
  end
end
