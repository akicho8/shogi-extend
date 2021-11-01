# UserMailer のテストは動くのがあたりまえなので意味がない
# UserMailer を使うモデルでテストする

require "rails_helper"

RSpec.describe UserMailer, type: :mailer do
  include ActbSupport

  describe "user_created" do
    it do
      assert { UserMailer.user_created(user1) }
    end
  end
end
