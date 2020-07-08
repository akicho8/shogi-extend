require "rails_helper"

require "#{Rails.root}/spec/mailers/previews/user_preview"

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

  describe "question_owner_message" do
    before do
      question = Actb::Question.mock_question
      @mail = UserMailer.question_owner_message(question.messages.first)
    end

    it do
      assert { @mail.from == ["shogi.extend@gmail.com"] }
      assert { @mail.to   == ["user1@example.com"]        }
      assert { @mail.bcc  == ["shogi.extend@gmail.com"] }
    end
  end

  describe "question_other_message" do
    before do
      question = Actb::Question.mock_question
      user = question.messages.first.user
      message = question.messages.second
      @mail = UserMailer.question_other_message(user, message)
    end

    it do
      assert { @mail.from == ["shogi.extend@gmail.com"] }
      assert { @mail.to   == ["user2@example.com"]        }
      assert { @mail.bcc  == ["shogi.extend@gmail.com"] }
    end
  end

end
# >> Run options: exclude {:slow_spec=>true}
# >> ...|---------------------+-------------------------------------------|
# >> |                  id | 99                                        |
# >> |                 key | 82b1054fa8467117df013a50e62a1b64          |
# >> |             user_id | 233                                       |
# >> |           folder_id | 697                                       |
# >> |          lineage_id | 1                                         |
# >> |           init_sfen | 4k4/9/4G4/9/9/9/9/9/9 b G2r2b2g4s4n4l1p 1 |
# >> |      time_limit_sec |                                           |
# >> |    difficulty_level |                                           |
# >> |               title | (title1)                                  |
# >> |         description |                                           |
# >> |           hint_desc |                                           |
# >> |       source_author |                                           |
# >> |   source_media_name |                                           |
# >> |    source_media_url |                                           |
# >> | source_published_on |                                           |
# >> |          created_at | 2020-07-08 17:15:51 +0900                 |
# >> |          updated_at | 2020-07-08 17:15:51 +0900                 |
# >> |           good_rate | 0.0                                       |
# >> | moves_answers_count | 1                                         |
# >> |     histories_count | 0                                         |
# >> |    good_marks_count | 0                                         |
# >> |     bad_marks_count | 0                                         |
# >> |    clip_marks_count | 0                                         |
# >> |      messages_count | 2                                         |
# >> |   direction_message |                                           |
# >> |---------------------+-------------------------------------------|
# >> .
# >> 
# >> Finished in 1.05 seconds (files took 2.2 seconds to load)
# >> 4 examples, 0 failures
# >> 
