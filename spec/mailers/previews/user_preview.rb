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
    user = User.create!
    battle = Swars::Battle.create!
    crawl_reservation = user.swars_crawl_reservations.create!(:target_user_key => battle.users.first.key)
    UserMailer.battle_fetch_notify(crawl_reservation)
  end

  # http://localhost:3000/rails/mailers/user/xconv_notify
  def xconv_notify
    convert_params = {
      :sleep         => 0,
      :raise_message => "",
      :board_binary_generator_params => {
        :to_format     => "gif",
        :loop_key      => "is_loop_infinite",
        :delay_per_one => 1,
      },
    }

    free_battle = FreeBattle.create!(kifu_body: "68S", use_key: "adapter", user: User.sysop)
    xconv_record = XconvRecord.create!(recordable: free_battle, user: User.sysop, convert_params: convert_params)
    UserMailer.xconv_notify(xconv_record)
  end
end
