class DropEmox < ActiveRecord::Migration[5.1]
  def up
    [
      :emox_bad_marks,
      :emox_battle_memberships,
      :emox_battles,
      :emox_clip_marks,
      :emox_emotions,
      :emox_folders,
      :emox_good_marks,
      :emox_histories,
      :emox_lobby_messages,
      :emox_main_xrecords,
      :emox_moves_answers,
      :emox_notifications,
      :emox_ox_records,
      :emox_question_messages,
      :emox_questions,
      :emox_room_memberships,
      :emox_room_messages,
      :emox_rooms,
      :emox_season_xrecords,
      :emox_settings,
      :emox_vs_records,
    ].each do |e|
      ForeignKey.disabled do
        drop_table e, if_exists: true
      end
    end
  end
end
