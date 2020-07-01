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

  describe "question_message_created" do
    before do
      Actb.setup
      user1 = User.create!(name: "user1", email: "user1@localhost")
      user2 = User.create!(name: "user2", email: "user2@localhost")
      question = user1.actb_questions.mock_type1
      message = question.messages.create!(user: user2, body: "(message)")
      @mail = UserMailer.question_message_created(message)
    end

    it do
      assert { @mail.from == ["shogi.extend@gmail.com"] }
      assert { @mail.to   == ["user1@localhost"]        }
      assert { @mail.bcc  == ["shogi.extend@gmail.com"] }
    end
  end
end
# >> Run options: exclude {:slow_spec=>true}
# >> ...
# >> 
# >> Finished in 0.68275 seconds (files took 2.1 seconds to load)
# >> 3 examples, 0 failures
# >> 
