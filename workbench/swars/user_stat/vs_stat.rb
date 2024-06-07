require "./setup"
_ { Swars::User["SugarHuuko"].user_stat.vs_stat.to_chart } # => "144.63 ms"
s { Swars::User["SugarHuuko"].user_stat.vs_stat.to_chart } # => [{:grade_name=>"八段", :judge_counts=>{:draw=>2}, :appear_ratio=>0.04}, {:grade_name=>"七段", :judge_counts=>{:lose=>5, :win=>6}, :appear_ratio=>0.22}, {:grade_name=>"六段", :judge_counts=>{:win=>14, :lose=>1}, :appear_ratio=>0.3}, {:grade_name=>"五段", :judge_counts=>{:win=>11, :lose=>2}, :appear_ratio=>0.26}, {:grade_name=>"四段", :judge_counts=>{:win=>6, :draw=>1}, :appear_ratio=>0.14}, {:grade_name=>"三段", :judge_counts=>{:win=>1}, :appear_ratio=>0.02}, {:grade_name=>"9級", :judge_counts=>{:win=>1}, :appear_ratio=>0.02}]
tp Swars::User["SugarHuuko"].user_stat.vs_stat.to_chart
# >>   Swars::User Load (0.1ms)  SELECT `swars_users`.* FROM `swars_users` WHERE `swars_users`.`user_key` = 'SugarHuuko' LIMIT 1
# >>   ↳ app/models/swars/user.rb:5:in `[]'
# >>   Swars::Membership Ids (10.9ms)  SELECT `swars_memberships`.`id` FROM `swars_memberships` INNER JOIN `swars_battles` ON `swars_battles`.`id` = `swars_memberships`.`battle_id` WHERE `swars_memberships`.`op_user_id` = 17413 ORDER BY `swars_battles`.`battled_at` DESC LIMIT 50
# >>   ↳ app/models/swars/user_stat/vs_stat.rb:88:in `ids'
# >>   Swars::Membership Count (0.3ms)  SELECT COUNT(*) AS `count_all`, `swars_grades`.`key` AS `swars_grades_key`, `judges`.`key` AS `judges_key` FROM `swars_memberships` INNER JOIN `swars_grades` ON `swars_grades`.`id` = `swars_memberships`.`grade_id` INNER JOIN `judges` ON `judges`.`id` = `swars_memberships`.`judge_id` WHERE `swars_memberships`.`id` IN (98271895, 98271897, 98271898, 98271901, 98271903, 98271904, 98271906, 98271908, 98271910, 98271912, 98303205, 98212764, 98212765, 98212767, 98212770, 98212772, 98212773, 98208929, 98212776, 98212777, 98263993, 98263996, 98263997, 98263999, 98264002, 98264004, 98264006, 98264008, 98196868, 98196870, 98196873, 98196875, 98196877, 98196879, 98196880, 98196884, 98196898, 98196900, 98196902, 98196908, 98196910, 98196912, 98196914, 98191815, 97909142, 97909145, 97904864, 97904486, 97904488, 97904489) GROUP BY `swars_grades`.`key`, `judges`.`key` ORDER BY `swars_grades`.`priority` ASC
# >>   ↳ app/models/swars/user_stat/vs_stat.rb:17:in `to_chart'
# >> |------------+----------------------+--------------|
# >> | grade_name | judge_counts         | appear_ratio |
# >> |------------+----------------------+--------------|
# >> | 八段       | {:draw=>2}           |         0.04 |
# >> | 七段       | {:lose=>5, :win=>6}  |         0.22 |
# >> | 六段       | {:win=>14, :lose=>1} |          0.3 |
# >> | 五段       | {:win=>11, :lose=>2} |         0.26 |
# >> | 四段       | {:win=>6, :draw=>1}  |         0.14 |
# >> | 三段       | {:win=>1}            |         0.02 |
# >> | 9級        | {:win=>1}            |         0.02 |
# >> |------------+----------------------+--------------|
