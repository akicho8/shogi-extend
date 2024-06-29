class RenameTagNanakawaryu < ActiveRecord::Migration[6.0]
  def change
    ActsAsTaggableOn::Tag.find_by(name: "菜々河流")&.update!(name: "菜々河流△４四角")
    ["菜々河流△４四角", "菜々河流向かい飛車"].each do |e|
      if tag = ActsAsTaggableOn::Tag.find_by(name: e)
        tag.taggings.where(taggable_type: "Swars::Membership").order(created_at: :desc).in_batches.each_record { |e| e.taggable.battle.rebuild rescue nil }
      end
    end
  end
end
