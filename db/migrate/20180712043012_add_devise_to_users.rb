# frozen_string_literal: true

class AddDeviseToUsers < ActiveRecord::Migration[5.2]
  def self.up
    change_table :colosseum_users do |t|
      ## Database authenticatable
      t.string :email,              null: false
      t.string :encrypted_password, null: false

      ## Recoverable
      t.string   :reset_password_token
      t.datetime :reset_password_sent_at

      ## Rememberable
      t.datetime :remember_created_at

      ## Trackable
      t.integer  :sign_in_count, default: 0, null: false
      t.datetime :current_sign_in_at
      t.datetime :last_sign_in_at
      t.string   :current_sign_in_ip
      t.string   :last_sign_in_ip

      ## Confirmable
      t.string   :confirmation_token
      t.datetime :confirmed_at
      t.datetime :confirmation_sent_at
      t.string   :unconfirmed_email # Only if using reconfirmable

      ## Lockable
      t.integer  :failed_attempts, default: 0, null: false # Only if lock strategy is :failed_attempts
      t.string   :unlock_token # Only if unlock strategy is :email or :both
      t.datetime :locked_at

      # 元のモデルにタイムスタンプが含まれていない場合は、コメントを外してください。
      # t.timestamps null: false

      t.index :email,                unique: true
      t.index :reset_password_token, unique: true
      t.index :confirmation_token,   unique: true
      t.index :unlock_token,         unique: true
    end

    create_table :colosseum_auth_infos do |t|
      t.belongs_to :user, null: false, comment: "ユーザー"
      t.string :provider, null: false, comment: "何経由でログインしたか"
      t.string :uid,      null: false, comment: "長い内部ID(providerとペアではユニーク)"
      t.text :meta_info,               comment: "とれた情報をハッシュで持っとく用"

      t.index [:provider, :uid], unique: true
    end
  end

  def self.down
    # By default, we don't want to make any assumption about how to roll back a migration when your
    # model already existed. Please edit below which fields you would like to remove in this migration.
    raise ActiveRecord::IrreversibleMigration
  end
end
