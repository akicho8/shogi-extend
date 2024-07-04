require "./setup"
throttle = Throttle.new(expires_in: 0.1)
throttle.reset
throttle.run { true }             # => true
throttle.run { true }             # => false
sleep(0.1)
throttle.run { true }             # => true
throttle.run { true }             # => false
