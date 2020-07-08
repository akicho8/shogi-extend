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
  # http://0.0.0.0:3000/rails/mailers/user/question_owner_message
  def question_owner_message
    question = Actb::Question.mock_question
    UserMailer.question_owner_message(question.messages.first)
  end

  # alice が作った問題に bob がコメントしたとき以前コメントした carol にメールが飛ぶ
  # http://0.0.0.0:3000/rails/mailers/user/question_other_message
  def question_other_message
    question = Actb::Question.mock_question
    user = question.messages.first.user
    message = question.messages.second
    UserMailer.question_other_message(user, message)
  end
end
