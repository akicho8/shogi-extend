class CreateSwarsBanAndProfile < ActiveRecord::Migration[5.1]
  def up
    begin
      # Swars::User
      change_table :swars_users do |t|
        t.datetime :ban_at, null: true, index: true, comment: "垢BAN日時"
      end
    rescue => error
      p error
    end

    # Swars::BanCrawlRequest
    create_table :swars_ban_crawl_requests, force: true do |t|
      t.belongs_to :user, null: false,                     comment: "BAN判定対象者"
      t.timestamps        null: false
    end

    # Swars::Profile
    create_table :swars_profiles, force: true do |t|
      t.belongs_to :user,         null: false,             comment: "対局者"
      t.datetime :ban_at,         null: true, index: true, comment: "垢BAN日時"
      t.datetime :ban_crowled_at, null: true,              comment: "垢BANクロール日時"
      t.integer :ban_crowl_count, null: true,              comment: "垢BANクロール回数"
      t.timestamps                null: false
    end

    Swars::User.reset_column_information
    AppLog.info(subject: self.class.name, body: [Swars::User.count, Swars::Profile.count], mail_notify: true)
    Swars::User.where.missing(:profile).find_each(&:save!)
    AppLog.info(subject: self.class.name, body: [Swars::User.count, Swars::Profile.count], mail_notify: true)
  end
end
