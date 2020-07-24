class TableRefactor13 < ActiveRecord::Migration[6.0]
  def up
    [
      :actb_lobby_messages,
      :actb_room_messages,
      :actb_question_messages,
    ].each do |e|
      change_column e, :body, :string, limit: 512
    end
  end
end
