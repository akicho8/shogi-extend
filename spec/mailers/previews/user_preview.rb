# http://localhost:3000/rails/mailers/user

class UserPreview < ActionMailer::Preview
  # http://localhost:3000/rails/mailers/user/battle_fetch_notify
  def battle_fetch_notify
    user = User.create!
    battle = Swars::Battle.create!
    crawl_reservation = user.swars_crawl_reservations.create!(:target_user_key => battle.users.first.key)
    UserMailer.battle_fetch_notify(crawl_reservation)
  end
end
