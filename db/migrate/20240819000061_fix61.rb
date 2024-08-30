class Fix61 < ActiveRecord::Migration[6.0]
  def change
    [
      :emox_emotion_folders,
      :emox_finals,
      :emox_judges,
      :emox_lineages,
      :emox_ox_marks,
      :emox_rules,
      :emox_seasons,
      :emox_skills,
      :emox_source_abouts,
      :transient_aggregates,
    ].each do |e|
      drop_table e, if_exists: true
    end
  end
end
