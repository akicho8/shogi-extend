class CreateShareBoard6 < ActiveRecord::Migration[5.1]
  def up
    change_table :share_board_chat_messages do |t|
      t.string :session_id, null: false, comment: "Rails の発行する session_id"
    end

    ShareBoard::ChatMessage.reset_column_information
    ShareBoard::ChatMessage.update_all(%(session_id = ""))
  end
end
