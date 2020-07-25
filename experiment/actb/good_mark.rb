require "./setup"

Actb::Question.destroy_all

user1 = User.create!
user2 = User.create!

question1 = user1.actb_questions.create_mock1
user2.actb_good_marks.create!(question: question1)

user2.actb_good_marks.count     # => 1

ActiveSupport::LogSubscriber.colorize_logging = false
logger = ActiveRecord::Base.logger = ActiveSupport::Logger.new(STDOUT)
ActiveRecord::Base.logger = ActiveSupport::Logger.new(STDOUT)

user1.actb_questions.count                  # => 1
user1.actb_questions.average(:good_rate)    # => 0.0
user1.actb_questions.sum(:good_marks_count) # => 1
user1.actb_questions.sum(:bad_marks_count)  # => 0
# >>    (0.5ms)  SELECT COUNT(*) FROM `actb_questions` WHERE `actb_questions`.`user_id` = 54
# >>    (0.6ms)  SELECT AVG(`actb_questions`.`good_rate`) FROM `actb_questions` WHERE `actb_questions`.`user_id` = 54
# >>    (0.4ms)  SELECT SUM(`actb_questions`.`good_marks_count`) FROM `actb_questions` WHERE `actb_questions`.`user_id` = 54
# >>    (0.4ms)  SELECT SUM(`actb_questions`.`bad_marks_count`) FROM `actb_questions` WHERE `actb_questions`.`user_id` = 54
