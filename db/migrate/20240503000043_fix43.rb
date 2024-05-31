class Fix43 < ActiveRecord::Migration[6.0]
  def up
    unless Rails.env.local?
      # Rails.application.credentials[:expert_import_user_keys].each do |user_key|
      #   say_with_time "#{user_key}" do
      #     AppLog.important("#{user_key} start")
      #     if user = Swars::User.find_by(key: user_key)
      #       s = user.battles.limit(200).order(battled_at: :desc)
      #       s = s.where(Swars::Battle.arel_table[:updated_at].lt(Time.parse("2024/05/31 18:00")))
      #       s.in_batches.each_record(&:remake)
      #     end
      #     AppLog.important("#{user_key} done")
      #   end
      # end
      # raise "OK"

      # say_with_time "all" do
      #   s = Swars::Membership
      #   s = s.joins(:battle)
      #   s = s.where(Swars::Battle.arel_table[:battled_at].gteq(Time.parse("2024/05/23")))
      #   s = s.where(ai_gear_freq: nil)
      #   s.find_each { |e| e.ai_columns_set; e.save(validate: false) }
      #   AppLog.important("all done")
      # end
    end
  end
end
