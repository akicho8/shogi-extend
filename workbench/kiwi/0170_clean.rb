require "./setup"

ActiveRecord::Base.logger = ActiveSupport::Logger.new(STDOUT)
# tp Kiwi::Lemon.destroy_all
Kiwi::Lemon.cleaner(expires_in: 0.days).call
