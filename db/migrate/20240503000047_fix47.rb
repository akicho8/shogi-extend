class Fix47 < ActiveRecord::Migration[6.0]
  def up
    ActsAsTaggableOn::Tag.find_by!(name: "相振り").update!(name: "相振り飛車")
    ActsAsTaggableOn::Tag.find_by!(name: "対振り").update!(name: "対振り飛車")
  end
end
