require "./setup"
battles_max = 50
Swars::User.in_batches do |scope|
  scope = scope.joins(:battles)
  scope = scope.group("swars_users.id")
  scope = scope.having("COUNT(swars_battles.id) > ?", battles_max)
  scope.each do |user|
    if Swars::User::Vip.auto_crawl_user_keys.include?(user.key)
      battles_max2 = 10
    else
      battles_max2 = 50
    end
    battles = user.battles
    # puts battles.collect(&:accessed_at)
    battles = battles.order(accessed_at: :desc).offset(battles_max2)
    # puts
    # puts battles.collect(&:accessed_at)
    p [user.key, battles.size]
    # battles.destroy_all
    exit
  end
end
