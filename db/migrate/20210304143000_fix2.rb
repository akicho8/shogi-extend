class Fix2 < ActiveRecord::Migration[6.0]
  def change
    ActsAsTaggableOn::Tag.find_by!(name: "中原玉").update!(name: "中原囲い")
    ActsAsTaggableOn::Tag.find_by!(name: "片矢倉").update!(name: "天野矢倉")
    ActsAsTaggableOn::Tag.find_by!(name: "雁木囲い").update!(name: "オールド雁木")
    ActsAsTaggableOn::Tag.find_by!(name: "elmo囲い").update!(name: "エルモ囲い")

    tag = ActsAsTaggableOn::Tag.find_by!(name: "右玉")
    tag.taggings.where(context: "attack_tags").update_all("context = 'defense_tags'")
    tag = ActsAsTaggableOn::Tag.find_by!(name: "高田流左玉")
    tag.taggings.where(context: "attack_tags").update_all("context = 'defense_tags'")
  end
end
