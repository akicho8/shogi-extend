require File.expand_path('../../../config/environment', __FILE__)
ApplicationRecord.connection.execute("SET foreign_key_checks = 0")

Swars::Battle.destroy_all
Swars::User.destroy_all

user1 = Swars::User.create!
user2 = Swars::User.create!

create = -> s, n {
  grade = Swars::Grade.fetch(s)
  n.times do
    Swars::Battle.create! do |e|
      e.memberships.build(user: user1, grade: grade)
      e.memberships.build(user: user2, grade: grade)
    end
  end
}

create.call("30級", 1)
create.call("2級", 1)
create.call("1級", 2)
# create.call("初段", 3)
# create.call("二段", 2)
# create.call("三段", 1)

ActiveSupport::LogSubscriber.colorize_logging = false
ActiveRecord::Base.logger = ActiveSupport::Logger.new(STDOUT)

tp Swars::Histogram::Grade.new({}).as_json

# s = Swars::Membership.all
# # s = s.joins(:battle).merge(Swars::Battle.rule_eq("10分"))
# # s = s.tagged_with("新嬉野流")
# s = s.where(grade: Swars::Grade.all.unscope(:order))
# ids = s.order(id: :desc).pluck(:id)
# counts = Swars::Membership.where(id: ids).group(:grade).count
# tp counts

# tp Swars::Membership.tagged_with("")
# tp Swars::Membership.tag_counts_on(:attack_tags)

# tp Swars::User
# tp Swars::Membership

# >>    (0.5ms)  SELECT `swars_memberships`.`id` FROM `swars_memberships` ORDER BY `swars_memberships`.`id` DESC LIMIT 20000
# >>   ↳ app/models/swars/histogram/grade.rb:39:in `block in target_ids'
# >>    (0.7ms)  SELECT COUNT(*) AS count_all, `swars_memberships`.`grade_id` AS swars_memberships_grade_id FROM `swars_memberships` WHERE `swars_memberships`.`id` IN (1510, 1509, 1508, 1507, 1506, 1505) AND `swars_memberships`.`grade_id` IN (SELECT `swars_grades`.`id` FROM `swars_grades` WHERE `swars_grades`.`key` IN ('九段', '八段', '七段', '六段', '五段', '四段', '三段', '二段', '初段', '1級', '2級', '3級', '4級', '5級', '6級', '7級', '8級', '9級')) GROUP BY `swars_memberships`.`grade_id`
# >>   ↳ app/models/swars/histogram/grade.rb:64:in `block in counts_hash'
# >>   Swars::Grade Load (0.4ms)  SELECT `swars_grades`.* FROM `swars_grades` WHERE `swars_grades`.`id` IN (11, 12) ORDER BY `swars_grades`.`priority` ASC
# >>   ↳ app/models/swars/histogram/grade.rb:64:in `block in counts_hash'
# >> |------------------------------------+---|
# >> | #<Swars::Grade:0x00007fa2999a8970> | 4 |
# >> | #<Swars::Grade:0x00007fa2999a88a8> | 2 |
# >> |------------------------------------+---|
# >>    (0.5ms)  SELECT COUNT(*) AS count_all, `swars_memberships`.`grade_id` AS swars_memberships_grade_id FROM `swars_memberships` WHERE `swars_memberships`.`id` IN (1510, 1509, 1508, 1507, 1506, 1505) AND `swars_memberships`.`grade_id` IN (SELECT `swars_grades`.`id` FROM `swars_grades` WHERE `swars_grades`.`key` IN ('九段', '八段', '七段', '六段', '五段', '四段', '三段', '二段', '初段', '1級', '2級', '3級', '4級', '5級', '6級', '7級', '8級', '9級')) GROUP BY `swars_memberships`.`grade_id`
# >>   ↳ app/models/swars/histogram/grade.rb:66:in `block in counts_hash'
# >>   Swars::Grade Load (0.4ms)  SELECT `swars_grades`.* FROM `swars_grades` WHERE `swars_grades`.`id` IN (11, 12) ORDER BY `swars_grades`.`priority` ASC
# >>   ↳ app/models/swars/histogram/grade.rb:66:in `block in counts_hash'
# >> |---------------------+-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
# >> |                 key | eeb8d959ff195c44a6b95d274e09ca82                                                                                                                                                                                                                                                                                                                                                                      |
# >> |      histogram_name | 棋力                                                                                                                                                                                                                                                                                                                                                                                                  |
# >> |         current_max | 20000                                                                                                                                                                                                                                                                                                                                                                                                 |
# >> |          updated_at | 2022-03-17 08:40:11 +0900                                                                                                                                                                                                                                                                                                                                                                             |
# >> |        sample_count | 6                                                                                                                                                                                                                                                                                                                                                                                                     |
# >> |             records | [{:grade=>{"id"=>11, "key"=>"1級", "priority"=>10}, :count=>4, :ratio=>0.6666666666666666}, {:grade=>{"id"=>12, "key"=>"2級", "priority"=>11}, :count=>2, :ratio=>0.3333333333333333}]                                                                                                                                                                                                                |
# >> | custom_chart_params | {:data=>{:labels=>["2", "1"], :datasets=>[{:label=>nil, :data=>[2, 4]}]}, :scales_yAxes_ticks=>{}}                                                                                                                                                                                                                                                                                                    |
# >> |           cache_key | Swars::Histogram::Grade/20000//                                                                                                                                                                                                                                                                                                                                                                       |
# >> |       default_limit | 20000                                                                                                                                                                                                                                                                                                                                                                                                 |
# >> |   default_limit_max | 50000                                                                                                                                                                                                                                                                                                                                                                                                 |
# >> |            max_list | [1000, 10000, 20000]                                                                                                                                                                                                                                                                                                                                                                                  |
# >> |            rule_key |                                                                                                                                                                                                                                                                                                                                                                                                       |
# >> |                xtag |                                                                                                                                                                                                                                                                                                                                                                                                       |
# >> |   xtag_select_names | ["天守閣囲い", "居玉", "カニ囲い", "カブト囲い", "金矢倉", "銀矢倉", "角矢倉", "豆腐矢倉", "隅矢倉", "矢倉右玉", "流れ矢倉", "四角矢倉", "へこみ矢倉", "カタ囲い", "悪形矢倉", "天野矢倉", "総矢倉", "金門矢倉", "矢倉穴熊", "菊水矢倉", "銀立ち矢倉", "菱矢倉", "一文字矢倉", "富士見矢倉", "矢倉早囲い", "土居矢倉", "高矢倉", "カニ缶囲い", "オリジナル雁木", "オールド雁木", "ツノ銀雁木", "新... |
# >> |---------------------+-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
