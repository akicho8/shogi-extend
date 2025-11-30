class CreateShareBoard7 < ActiveRecord::Migration[5.1]
  def up
    # remove_column(:share_board_chat_messages, :user_avatar, if_exists: true)

    change_table :share_board_chat_messages do |t|
      t.string :user_selected_avatar, null: false, comment: "アバター(1文字の絵文字)"
    end

    ShareBoard::ChatMessage.reset_column_information
    ShareBoard::ChatMessage.update_all(%(user_selected_avatar = ""))
  end
end
