require "./setup"
# Swars::User["abacus10"].battles.in_batches.each_record { |e| p e.id }
# Swars::User["abacus10"].battles.limit(10).each(&:rebuild)
battle = Swars::User["abacus10"].battles.order(id: :desc).take(14).last
battle.rebuild                   # => true



# battle.memberships.first.note_tag_list # => ["居飛車", "相居飛車", "持久戦", "短手数"]
# battle.memberships.collect { |e| e.taggings.collect { |e| e.tag.name } } # => [["手得角交換型", "角換わり腰掛け銀", "角換わり新型", "居飛車", "相居飛車", "持久戦", "短手数"], ["一手損角換わり", "角換わり右玉", "居飛車", "相居飛車", "持久戦", "短手数", "垂れ歩"]]
# 
# s
# battle.parsed_data_to_columns_set
# battle.memberships.each(&:save!)   # 更新で設定したタグを保存するため
# battle.save!
# battle.memberships.collect(&:note_tag_list) # => [["居飛車", "相居飛車", "持久戦", "短手数"], ["居飛車", "相居飛車", "持久戦", "短手数"]]

# a = taggings.collect { |e| e.tag.name }.sort
# updated = a != b # タグの変更は e.changed? では関知できない
# print(updated ? "U" : ".")
# updated
# >> U
