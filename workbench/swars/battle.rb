require "./setup"
ActiveRecord::Base.logger = nil
count = Swars::User.count
Swars::User.find_in_batches do |g|
  updated = 0
  g.each do |user|
    if battled_at = user.battles.maximum(:battled_at)
      Retryable.retryable(on: ActiveRecord::Deadlocked) do
        user.update!(latest_battled_at: battled_at)
      end
      updated += 1
    end
  end
  count -= g.size
  p [count, updated]
end
