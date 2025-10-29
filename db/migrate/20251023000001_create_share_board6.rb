class CreateShareBoard6 < ActiveRecord::Migration[5.1]
  def up
    change_table :share_board_chat_messages do |t|
      t.string :client_token, null: false, comment: "クライアント固有の識別子"
    end

    ShareBoard::ChatMessage.reset_column_information
    ShareBoard::ChatMessage.update_all(%(client_token = ""))
  end
end
