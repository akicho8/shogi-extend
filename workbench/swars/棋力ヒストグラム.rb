require File.expand_path('../../../config/environment', __FILE__)
ForeignKey.disabled

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

# >>    (0.4ms)  SELECT `swars_memberships`.`id` FROM `swars_memberships` ORDER BY `swars_memberships`.`id` DESC LIMIT 2
# >>   ↳ app/models/swars/histogram/grade.rb:64:in `counts_hash'
# >>    (0.4ms)  SELECT COUNT(*) FROM `swars_memberships` WHERE `swars_memberships`.`id` IN (404, 403)
# >>   ↳ app/models/swars/histogram/grade.rb:69:in `block in counts_hash'
# >>    (0.4ms)  SELECT COUNT(*) AS count_all, `swars_memberships`.`grade_id` AS swars_memberships_grade_id FROM `swars_memberships` WHERE `swars_memberships`.`id` IN (404, 403) GROUP BY `swars_memberships`.`grade_id`
# >>   ↳ app/models/swars/histogram/grade.rb:89:in `block in counts_hash'
# >>    (0.3ms)  SELECT `swars_memberships`.`id` FROM `swars_memberships` WHERE `swars_memberships`.`id` < 403 ORDER BY `swars_memberships`.`id` DESC LIMIT 2
# >>   ↳ app/models/swars/histogram/grade.rb:64:in `counts_hash'
# >>    (0.3ms)  SELECT COUNT(*) FROM `swars_memberships` WHERE `swars_memberships`.`id` IN (402, 401)
# >>   ↳ app/models/swars/histogram/grade.rb:69:in `block in counts_hash'
# >>    (1.2ms)  SELECT COUNT(*) AS count_all, `swars_memberships`.`grade_id` AS swars_memberships_grade_id FROM `swars_memberships` WHERE `swars_memberships`.`id` IN (402, 401) GROUP BY `swars_memberships`.`grade_id`
# >>   ↳ app/models/swars/histogram/grade.rb:89:in `block in counts_hash'
# >>    (0.6ms)  SELECT `swars_memberships`.`id` FROM `swars_memberships` WHERE `swars_memberships`.`id` < 401 ORDER BY `swars_memberships`.`id` DESC LIMIT 2
# >>   ↳ app/models/swars/histogram/grade.rb:64:in `counts_hash'
# >>    (0.4ms)  SELECT COUNT(*) FROM `swars_memberships` WHERE `swars_memberships`.`id` IN (400, 399)
# >>   ↳ app/models/swars/histogram/grade.rb:69:in `block in counts_hash'
# >>    (0.4ms)  SELECT COUNT(*) AS count_all, `swars_memberships`.`grade_id` AS swars_memberships_grade_id FROM `swars_memberships` WHERE `swars_memberships`.`id` IN (400, 399) GROUP BY `swars_memberships`.`grade_id`
# >>   ↳ app/models/swars/histogram/grade.rb:89:in `block in counts_hash'
# >>    (0.3ms)  SELECT `swars_memberships`.`id` FROM `swars_memberships` WHERE `swars_memberships`.`id` < 399 ORDER BY `swars_memberships`.`id` DESC LIMIT 2
# >>   ↳ app/models/swars/histogram/grade.rb:64:in `counts_hash'
# >>    (0.3ms)  SELECT COUNT(*) FROM `swars_memberships` WHERE `swars_memberships`.`id` IN (398, 397)
# >>   ↳ app/models/swars/histogram/grade.rb:69:in `block in counts_hash'
# >>    (0.3ms)  SELECT COUNT(*) AS count_all, `swars_memberships`.`grade_id` AS swars_memberships_grade_id FROM `swars_memberships` WHERE `swars_memberships`.`id` IN (398, 397) GROUP BY `swars_memberships`.`grade_id`
# >>   ↳ app/models/swars/histogram/grade.rb:89:in `block in counts_hash'
# >>    (0.3ms)  SELECT `swars_memberships`.`id` FROM `swars_memberships` WHERE `swars_memberships`.`id` < 397 ORDER BY `swars_memberships`.`id` DESC LIMIT 2
# >>   ↳ app/models/swars/histogram/grade.rb:64:in `counts_hash'
# >>   Swars::Grade Load (0.5ms)  SELECT `swars_grades`.* FROM `swars_grades` WHERE `swars_grades`.`key` IN ('九段', '八段', '七段', '六段', '五段', '四段', '三段', '二段', '初段', '1級', '2級', '3級', '4級', '5級', '6級', '7級', '8級', '9級') ORDER BY `swars_grades`.`priority` ASC
# >>   ↳ app/models/swars/histogram/grade.rb:115:in `collect'
# >> |---------------------+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
# >> |       processed_second | 0.018678999971598387                                                                                                                                                                                                                                                                                                                                                                                                      |
# >> |                 key | 905fb05fc7315f263ea581a3ac49979e                                                                                                                                                                                                                                                                                                                                                                                          |
# >> |      histogram_name | 棋力                                                                                                                                                                                                                                                                                                                                                                                                                      |
# >> |         current_max | 20000                                                                                                                                                                                                                                                                                                                                                                                                                     |
# >> |          updated_at | 2022-05-22 17:26:10 +0900                                                                                                                                                                                                                                                                                                                                                                                                 |
# >> |        sample_count | 8                                                                                                                                                                                                                                                                                                                                                                                                                         |
# >> |           cache_key | Swars::Histogram::Grade/20000//                                                                                                                                                                                                                                                                                                                                                                                           |
# >> |       default_limit | 20000                                                                                                                                                                                                                                                                                                                                                                                                                     |
# >> |   default_limit_max | 20000                                                                                                                                                                                                                                                                                                                                                                                                                     |
# >> |            max_list | [5000, 10000, 20000]                                                                                                                                                                                                                                                                                                                                                                                                      |
# >> |             records | [{:grade=>{"id"=>2, "key"=>"九段", "priority"=>1}, :count=>0, :ratio=>0.0}, {:grade=>{"id"=>3, "key"=>"八段", "priority"=>2}, :count=>0, :ratio=>0.0}, {:grade=>{"id"=>4, "key"=>"七段", "priority"=>3}, :count=>0, :ratio=>0.0}, {:grade=>{"id"=>5, "key"=>"六段", "pri...                                                                                                                                               |
# >> | custom_chart_params | {:data=>{:labels=>["9", "8", "7", "6", "5", "4", "3", "2", "1", "初", "二", "三", "四", "五", "六", "七", "八", "九"], :datasets=>[{:label=>nil, :data=>[0, 0, 0, 0, 0, 0, 0, 2, 4, 0, 0, 0, 0, 0, 0, 0, 0, 0]}]}, :scales_y_axes_ticks=>nil, :scales_y_axes_display=>false...                                                                                                                                              |
# >> |            rule_key |                                                                                                                                                                                                                                                                                                                                                                                                                           |
# >> |                xtag |                                                                                                                                                                                                                                                                                                                                                                                                                           |
# >> |    real_total_count | 6                                                                                                                                                                                                                                                                                                                                                                                                                         |
# >> |   xtag_select_names | ["花村流名古屋戦法", "清野流岐阜戦法", "GAVA角", "▲5五龍中飛車", "ノーガード戦法", "▲3七銀戦法", "脇システム", "ウソ矢倉", "矢倉棒銀", "森下システム", "雀刺し", "米長流急戦矢倉", "カニカニ銀", "カニカニ金", "中原流急戦矢倉", "阿久津流急戦矢倉", "藤森流急戦矢倉", "屋敷流二枚銀", "屋敷流二枚銀棒銀型", "矢倉中飛車", "右四間飛車", "原始棒銀", "かまいたち戦法", "英春流カメレオン", "パックマン戦法", "山崎... |
# >> |---------------------+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
