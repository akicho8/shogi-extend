class Fix25 < ActiveRecord::Migration[6.0]
  def change
    Swars::Membership.reset_column_information
    Swars::Membership.update_all("ai_drop_total = null")
  end
end
