class CreateSwarsBanAndProfile3 < ActiveRecord::Migration[5.1]
  def up
    # Swars::User
    change_table :swars_users do |t|
      unless t.column_exists?(:ban_at)
        t.datetime :ban_at, null: true, index: true, comment: "垢BAN日時"
      end
    end

    # Swars::BanCrawlRequest
    create_table :swars_ban_crawl_requests, force: true do |t|
      t.belongs_to :user, null: false,                     comment: "BAN判定対象者"
      t.timestamps        null: false
    end

    # Swars::Profile
    create_table :swars_profiles, force: true do |t|
      t.belongs_to :user,           null: false,             comment: "対局者"
      t.datetime :ban_at,           null: true, index: true, comment: "垢BAN日時"
      t.datetime :ban_crawled_at,   null: true,              comment: "垢BANクロール日時"
      t.integer :ban_crawled_count, null: true,              comment: "垢BANクロール回数"
      t.timestamps                  null: false
    end

    change_table :swars_users do |t|
      unless t.column_exists?(:latest_battled_at)
        t.datetime :latest_battled_at, null: true, comment: "直近の対局日時" rescue nil
      end
    end

    Swars::User.reset_column_information
    AppLog.info(subject: self.class.name, body: [Swars::User.count, Swars::Profile.count], mail_notify: true)
    Swars::User.where.missing(:profile).find_each(&:create_profile)
    AppLog.info(subject: self.class.name, body: [Swars::User.count, Swars::Profile.count], mail_notify: true)

    Swars::User.reset_column_information
    # Swars::User.find_each { |e| e.update!(latest_battled_at: nil) }
    AppLog.info(subject: self.class.name, body: Swars::User.where(latest_battled_at: nil).count, mail_notify: true)
    Swars::User.where(latest_battled_at: nil).find_each { |e| e.update!(latest_battled_at: e.memberships.joins(:battle).maximum(Swars::Battle.arel_table[:battled_at]) || e.created_at) }
    AppLog.info(subject: self.class.name, body: Swars::User.where(latest_battled_at: nil).count, mail_notify: true)
  end
end
