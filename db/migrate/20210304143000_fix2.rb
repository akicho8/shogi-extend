class Fix2 < ActiveRecord::Migration[6.0]
  def change
    ActsAsTaggableOn::Tag.find_by!(name: "中原玉").update!(name: "中原囲い")
    ActsAsTaggableOn::Tag.find_by!(name: "片矢倉").update!(name: "天野矢倉")
    ActsAsTaggableOn::Tag.find_by!(name: "雁木囲い").update!(name: "オールド雁木")
    ActsAsTaggableOn::Tag.find_by!(name: "elmo囲い").update!(name: "エルモ囲い")
  end
end
