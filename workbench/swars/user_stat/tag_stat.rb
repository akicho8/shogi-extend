require "./setup"

# 実行順序でかわる
ActsAsTaggableOn.strict_case_match = false
_ { Swars::User["SugarHuuko"].user_stat.all_tag.counts_hash } # => "206.90 ms"
ActsAsTaggableOn.strict_case_match = true
_ { Swars::User["SugarHuuko"].user_stat.all_tag.counts_hash } # => "27.60 ms"

# _ { Swars::User["SugarHuuko"].user_stat.all_tag.counts_hash[:"居飛車"] } # => "249.66 ms"
# s { Swars::User["SugarHuuko"].user_stat.all_tag.counts_hash[:"居飛車"] } # => 50
# s { Swars::User["SugarHuuko"].user_stat.win_tag.counts_hash[:"居飛車"] } # => 35
#
# Swars::User["SugarHuuko"].user_stat.win_tag.counts_hash[:"急戦"]   # => 17
# Swars::User["SugarHuuko"].user_stat.win_tag.counts_hash[:"持久戦"] # => 15
# Swars::User["SugarHuuko"].user_stat.ids_count                      # => 50
# Swars::User["SugarHuuko"].user_stat.win_ratio                      # => 0.7

# ActiveRecord::Base.connection.execute("ALTER TABLE tags MODIFY name varchar(255) CHARACTER SET utf8 COLLATE utf8_bin;") rescue $! # => #<ActiveRecord::StatementInvalid: Mysql2::Error: Incorrect string value: '\xF0\xA9\xB8\xBD' for column 'name' at row 60886>
# ActsAsTaggableOn::Tag.find_by(name: "\xF0\xA9\xB8\xBD") # => #<ActsAsTaggableOn::Tag id: 178924, name: "𩸽", taggings_count: 0>

# ActsAsTaggableOn::Tag.find_each do |e|
#   if e.name != e.name.toeuc.toutf8
#     p e.name
#   end
# end

# s { ActsAsTaggableOn.force_binary_collation = true; }
# s { ActsAsTaggableOn.force_binary_collation = true; }

# _ { ActsAsTaggableOn.force_binary_collation = false; Swars::Membership.tagged_with("居玉").count } # => "26214.05 ms"
# _ { ActsAsTaggableOn.force_binary_collation = true;  Swars::Membership.tagged_with("居玉").count } # => "2030.71 ms"

# ActsAsTaggableOn.strict_case_match # => false
# s { ActsAsTaggableOn.strict_case_match = true;  Swars::Membership.tagged_with("居玉").count } # => 632389
# s { ActsAsTaggableOn.strict_case_match = false; Swars::Membership.tagged_with("居玉").count } # => 632389

# ActsAsTaggableOn.strict_case_match                # => true
# _ { Swars::Membership.tagged_with("居玉").count } # => "2025.10 ms"

