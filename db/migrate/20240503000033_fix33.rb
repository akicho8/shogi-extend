class Fix33 < ActiveRecord::Migration[6.0]
  def up
    # Swars::User::Vip.auto_crawl_user_keys.each do |user_key|
    #   say_with_time "#{user_key}" do
    #     if user = Swars::User.find_by(key: user_key)
    #       user.battles.limit(nil).order(id: :desc).in_batches.each_record do |e|
    #         Retryable.retryable { e.rebuild }
    #       end
    #     end
    #   end
    # end
  end
end
