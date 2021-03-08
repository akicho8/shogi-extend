class Fix4 < ActiveRecord::Migration[6.0]
  def change
    # ActiveRecord::Base.logger = nil
    # ActsAsTaggableOn::Tag.find_by(name: "居玉")&.taggings&.where(context: "note_tags")&.in_batches.update_all("context = 'defense_tags'")

    ActsAsTaggableOn::Tag.find_by(name: "角換わり右玉")&.update!(name: "羽生流右玉")
  end
end
