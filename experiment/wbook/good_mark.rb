require "./setup"

Wbook::Question.destroy_all

user1 = User.create!
user2 = User.create!

question1 = user1.wbook_questions.create_mock1
user2.wbook_good_marks.create!(question: question1)

user2.wbook_good_marks.count     # => 1

ActiveSupport::LogSubscriber.colorize_logging = false
logger = ActiveRecord::Base.logger = ActiveSupport::Logger.new(STDOUT)
ActiveRecord::Base.logger = ActiveSupport::Logger.new(STDOUT)

user1.wbook_questions.count                  # => 1
user1.wbook_questions.average(:good_rate)    # => 0.0
user1.wbook_questions.sum(:good_marks_count) # => 1
user1.wbook_questions.sum(:bad_marks_count)  # => 0
# >>    (0.5ms)  SELECT COUNT(*) FROM `wbook_questions` WHERE `wbook_questions`.`user_id` = 54
# >>    (0.6ms)  SELECT AVG(`wbook_questions`.`good_rate`) FROM `wbook_questions` WHERE `wbook_questions`.`user_id` = 54
# >>    (0.4ms)  SELECT SUM(`wbook_questions`.`good_marks_count`) FROM `wbook_questions` WHERE `wbook_questions`.`user_id` = 54
# >>    (0.4ms)  SELECT SUM(`wbook_questions`.`bad_marks_count`) FROM `wbook_questions` WHERE `wbook_questions`.`user_id` = 54
