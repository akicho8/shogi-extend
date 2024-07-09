require "./setup"
count = Swars::User.count
Swars::User.find_in_batches do |g|
  g.each do |user|
    if battled_at = user.battles.maximum(:battled_at)
      user.update!(latest_battled_at: battled_at) rescue nil
    end
  end
  count -= g.size
  p count
end
