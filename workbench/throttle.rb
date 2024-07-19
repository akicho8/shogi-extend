require "./setup"

throttle = Throttle.new(expires_in: 0.1)
throttle.reset
throttle.call { true }             # => true
throttle.call { true }             # => false
sleep(0.1)
throttle.call { true }             # => true
throttle.call { true }             # => false
