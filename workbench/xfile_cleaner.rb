require File.expand_path('../../config/environment', __FILE__)
Rails.logger = ActiveSupport::TaggedLogging.new(ActiveSupport::Logger.new(STDOUT))
XfileCleaner.new.call
