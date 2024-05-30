class Fix36 < ActiveRecord::Migration[6.0]
  def up
    Swars::Membership.reset_column_information
    # Swars::Membership.update_all("ai_gear_freq = NULL")

    # Rails.application.credentials[:expert_import_user_keys].each do |user_key|
    #   say_with_time "#{user_key}" do
    #     if user = Swars::User.find_by(key: user_key)
    #       user.memberships.where(ai_gear_freq: nil).find_each { |e| e.ai_columns_set; e.save(validate: false) }
    #     end
    #   end
    # end

    [
      # "十段",
      "九段",
      "八段",
      "七段",
      "六段",
      "五段",
    ].each do |grade_key|
      say_with_time "#{grade_key}" do
        s = Swars::Grade[grade_key].memberships
        # s = Swars::Membership
        s = s.joins(:battle)
        s = s.where(Swars::Battle.arel_table[:battled_at].gteq(Time.parse("2024/05/23")))
        s = s.where(ai_gear_freq: nil)
        s.find_each { |e| e.ai_columns_set; e.save(validate: false) }
      end
    end

    # say_with_time "all" do
    #   Swars::Membership.where(ai_gear_freq: nil).find_each { |e| e.ai_columns_set; e.save(validate: false) }
    # end
  end
end
