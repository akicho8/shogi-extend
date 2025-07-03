require "#{__dir__}/setup"

require "#{__dir__}/../setup"

_ { ActiveRecord::Base.connection.tables } # =>
s { ActiveRecord::Base.connection.tables } # =>
