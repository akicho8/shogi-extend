# http://0.0.0.0:3000/rails/mailers/user

class UserPreview < ActionMailer::Preview
  # http://0.0.0.0:3000/rails/mailers/user/user_created
  def user_created
    if false
    # 次のようにして user を作ると初回は成功する
    #
    #   user = FactoryBot.create(:user)
    #
    # しかし、コードを変更して再読み込みすると次のエラーになる
    #
    # このアプリ以外でも同様のことがおきる
    else
      user = User.create!
    end

    UserMailer.user_created(user)
  end

  # alice が作った問題に bob がコメントしたとき alice にメールが飛ぶ
  # http://0.0.0.0:3000/rails/mailers/user/question_message_created
  def question_message_created
    Actb::Question.destroy_all

    user1 = User.create!(name: "user1")
    user2 = User.create!(name: "user2")
    question = user1.actb_questions.mock_type1
    message = question.messages.create!(user: user2, body: "message")
    UserMailer.question_message_created(message)
  end
end
