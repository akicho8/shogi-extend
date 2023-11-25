class CreateSwarsBanAndProfile3 < ActiveRecord::Migration[5.1]
  def up
    Swars::User.reset_column_information
    # Swars::User.find_each { |e| e.update!(latest_battled_at: nil) }
    AppLog.info(subject: self.class.name, body: Swars::User.where(latest_battled_at: nil).count, mail_notify: true)
    Swars::User.where(latest_battled_at: nil).find_each { |e| e.update!(latest_battled_at: e.memberships.joins(:battle).maximum(Swars::Battle.arel_table[:battled_at]) || e.created_at) }
    AppLog.info(subject: self.class.name, body: Swars::User.where(latest_battled_at: nil).count, mail_notify: true)
  end
end
