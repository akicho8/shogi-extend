class DropActb < ActiveRecord::Migration[5.1]
  def up
    [
      :actb_bad_marks,
      :actb_battle_memberships,
      :actb_battles,
      :actb_clip_marks,
      :actb_emotion_folders,
      :actb_emotions,
      :actb_finals,
      :actb_folders,
      :actb_good_marks,
      :actb_histories,
      :actb_judges,
      :actb_lineages,
      :actb_lobby_messages,
      :actb_main_xrecords,
      :actb_moves_answers,
      :actb_notifications,
      :actb_ox_marks,
      :actb_ox_records,
      :actb_question_messages,
      :actb_questions,
      :actb_room_memberships,
      :actb_room_messages,
      :actb_rooms,
      :actb_rules,
      :actb_season_xrecords,
      :actb_seasons,
      :actb_settings,
      :actb_skills,
      :actb_source_abouts,
      :actb_udemaes,
      :actb_vs_records,
    ].each do |e|
      ForeignKey.disabled do
        drop_table e, if_exists: true
      end
    end
  end
end
