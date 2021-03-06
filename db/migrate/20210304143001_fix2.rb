class Fix2 < ActiveRecord::Migration[6.0]
  def change
    # ActiveRecord::Base.logger = nil
    
    ActiveRecord::Base.connection.drop_table(:general_battles) rescue nil
    ActiveRecord::Base.connection.drop_table(:general_memberships) rescue nil
    ActiveRecord::Base.connection.drop_table(:general_users) rescue nil
    
    ActsAsTaggableOn::Tagging.where(taggable_type: "General::Battle").in_batches.destroy_all
    ActsAsTaggableOn::Tagging.where(taggable_type: "Swars::Battle").in_batches.destroy_all
    
    tp ActsAsTaggableOn::Tagging.group(:taggable_type).count
    
    ActsAsTaggableOn::Tag.find_by(name: "中原玉")&.update!(name: "中原囲い")
    ActsAsTaggableOn::Tag.find_by(name: "雁木囲い")&.update!(name: "オールド雁木")
    ActsAsTaggableOn::Tag.find_by(name: "elmo囲い")&.update!(name: "エルモ囲い")
    
    tp ActsAsTaggableOn::Tag.find_by(name: "片矢倉").taggings.count
    tp ActsAsTaggableOn::Tag.find_by(name: "天野矢倉").taggings.count
    
    ActsAsTaggableOn::Tag.find_by(name: "天野矢倉")&.update!(name: "天野矢倉2")
    ActsAsTaggableOn::Tag.find_by(name: "片矢倉")&.update!(name: "天野矢倉")
    ActsAsTaggableOn::Tag.find_by(name: "天野矢倉2")&.update!(name: "片矢倉")
    
    tp ActsAsTaggableOn::Tag.find_by(name: "片矢倉").taggings.count
    tp ActsAsTaggableOn::Tag.find_by(name: "天野矢倉").taggings.count
    
    ActsAsTaggableOn::Tag.find_by(name: "右玉")&.taggings&.where(context: "attack_tags")&.update_all("context = 'defense_tags'")
    ActsAsTaggableOn::Tag.find_by(name: "高田流左玉")&.taggings&.where(context: "attack_tags")&.update_all("context = 'defense_tags'")
    
    ActsAsTaggableOn::Tag.find_by(name: "５筋位取り")&.taggings&.where(context: "attack_tags")&.in_batches.destroy_all
  end
end
