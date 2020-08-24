require "./setup"

Xclock::Question.destroy_all

user1 = User.create!
user2 = User.create!

question1 = user1.xclock_questions.create_mock1
user2.xclock_good_marks.create!(question: question1)

user2.xclock_good_marks.count     # => 1

ActiveSupport::LogSubscriber.colorize_logging = false
logger = ActiveRecord::Base.logger = ActiveSupport::Logger.new(STDOUT)
ActiveRecord::Base.logger = ActiveSupport::Logger.new(STDOUT)

user1.xclock_questions.count                  # => 1
user1.xclock_questions.average(:good_rate)    # => 0.0
user1.xclock_questions.sum(:good_marks_count) # => 1
user1.xclock_questions.sum(:bad_marks_count)  # => 0
# >>    (0.5ms)  SELECT COUNT(*) FROM `xclock_questions` WHERE `xclock_questions`.`user_id` = 54
# >>    (0.6ms)  SELECT AVG(`xclock_questions`.`good_rate`) FROM `xclock_questions` WHERE `xclock_questions`.`user_id` = 54
# >>    (0.4ms)  SELECT SUM(`xclock_questions`.`good_marks_count`) FROM `xclock_questions` WHERE `xclock_questions`.`user_id` = 54
# >>    (0.4ms)  SELECT SUM(`xclock_questions`.`bad_marks_count`) FROM `xclock_questions` WHERE `xclock_questions`.`user_id` = 54
