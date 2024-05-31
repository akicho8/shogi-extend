class Fix42 < ActiveRecord::Migration[6.0]
  def up
    unless Rails.env.local?
      Swars::Membership.reset_column_information
      # Swars::Membership.update_all("ai_gear_freq = NULL")

      [
        "十段",
        "九段",
        "八段",
        "七段",
        "六段",
        "五段",
      ].each do |grade_key|
        say_with_time "#{grade_key}" do
          AppLog.important(grade_key)
          s = Swars::Grade[grade_key].memberships
          # s = Swars::Membership
          s = s.joins(:battle)
          s = s.where(Swars::Battle.arel_table[:battled_at].gteq(Time.parse("2024/05/23")))
          s = s.where(ai_gear_freq: nil)
          s.find_each do |e|
            e.ai_columns_set
            Retryable.retryable(on: ActiveRecord::Deadlocked) do
              e.save(validate: false)
            end
          end
        end
      end

      Rails.application.credentials[:expert_import_user_keys].each do |user_key|
        say_with_time "#{user_key}" do
          AppLog.important("#{user_key} start")
          if user = Swars::User.find_by(key: user_key)
            s = user.battles.limit(200).order(id: :desc)
            s = s.where(Swars::Battle.arel_table[:updated_at].lt(Time.parse("2024/05/31 12:00")))
            s.in_batches.each_record do |e|
              e.remake rescue nil
            end
          end
          AppLog.important("#{user_key} done")
        end
      end

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
