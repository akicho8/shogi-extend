class CreateShareBoard4 < ActiveRecord::Migration[5.1]
  def up
    change_table :share_board_rooms do |t|
      unless t.column_exists?(:chat_messages_count)
        t.integer :chat_messages_count, default: 0
      end
    end

    change_table :share_board_users do |t|
      unless t.column_exists?(:chat_messages_count)
        t.integer :chat_messages_count, default: 0
      end
    end

    create_table :share_board_chat_messages, force: true do |t|
      # 必須
      t.belongs_to :room,          null: false, comment: "部屋"
      t.belongs_to :user,          null: false, comment: "発言者(キーは名前だけなのですり変われる)"
      t.belongs_to :message_scope, null: false, comment: "スコープ"
      t.string :content,           null: false, comment: "発言内容", limit: 256
      t.bigint :performed_at,      null: false, comment: "実行開始日時(ms)"
      t.timestamps null: false
      # NULL許可
      t.belongs_to :real_user,     null: true,  comment: "ログインユーザー"
      t.string :from_connection_id,             comment: "null なら bot 等"
      t.string :primary_emoji,                  comment: "優先する絵文字"
    end

    create_table :share_board_message_scopes, force: true do |t|
      t.string :key,       null: false, index: { unique: true }
      t.integer :position, null: true,  index: true, comment: "順序"
      t.timestamps         null: false
    end
  end
end
