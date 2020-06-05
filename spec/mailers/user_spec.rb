require "rails_helper"

RSpec.describe UserMailer, type: :mailer do
  describe "user_created" do
    before do
      @user = User.create!
      @mail = UserMailer.user_created(@user)
    end

    it "renders the headers" do
      assert { @mail.subject }
      assert { @mail.to      }
      assert { @mail.from    }
    end

    it "renders the body" do
      assert { @mail.body.encoded }
    end
  end
end
