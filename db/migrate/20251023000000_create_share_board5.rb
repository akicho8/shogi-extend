class CreateShareBoard5 < ActiveRecord::Migration[5.1]
  def up
    change_table :share_board_chat_messages do |t|
      t.boolean :force_talk, null: false, comment: "ONなら必ず発声する"
    end

    ShareBoard::ChatMessage.reset_column_information
    ShareBoard::ChatMessage.update_all("force_talk = false")
  end
end
