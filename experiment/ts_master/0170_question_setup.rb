require "./setup"

# ActiveRecord::Base.logger = nil
# ActiveRecord::Base.connection.truncate(TsMaster::Question.table_name)
# TsMaster::Question.setup(block_size: 5000)

# ActiveRecord::Base.connection.truncate(TsMaster::Question.table_name)
# TsMaster::Question.setup(block_size: 90, max: 100)

ActiveRecord::Base.connection.truncate(Question.table_name)
TsMaster::Question.setup(mate: [3, 5, 7, 9, 11], block_size: 500, max: 500)
TsMaster::Question.group_mate_count # => {3=>500, 5=>500, 7=>500, 9=>500, 11=>500}
# >> [3, 500]
# >> [5, 500]
# >> [7, 500]
# >> [9, 500]
# >> [11, 500]
