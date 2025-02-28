require "#{__dir__}/../setup"

require "../setup"
_ { ActiveRecord::Base.connection.tables } # =>
s { ActiveRecord::Base.connection.tables } # =>
