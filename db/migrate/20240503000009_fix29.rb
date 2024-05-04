class Fix29 < ActiveRecord::Migration[6.0]
  def up
    # Swars::Membership.reset_column_information
    # Swars::Membership.update_all("ai_drop_total = null")

    # ["九段", "八段", "七段"].each do |grade_key|
    #   say_with_time "#{grade_key}" do
    #     Swars::Grade[grade_key].memberships.where(ai_drop_total: nil).find_each do |e|
    #       e.ai_columns_set
    #       begin
    #         e.save!(validate: false)
    #       rescue => error
    #         p error
    #       end
    #     end
    #   end
    # end
  end
end
