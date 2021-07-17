# http://localhost:3000/rails/mailers/user

class UserPreview < ActionMailer::Preview
  # http://localhost:3000/rails/mailers/user/user_created
  def user_created
    UserMailer.user_created(User.first)
  end

  # http://localhost:3000/rails/mailers/user/question_owner_message
  def question_owner_message
    UserMailer.question_owner_message(Actb::QuestionMessage.first)
  end

  # http://localhost:3000/rails/mailers/user/question_other_message
  def question_other_message
    UserMailer.question_other_message(User.first, Actb::QuestionMessage.first)
  end

  # http://localhost:3000/rails/mailers/user/battle_fetch_notify
  def battle_fetch_notify
    UserMailer.battle_fetch_notify(Swars::CrawlReservation.first)
  end
end
