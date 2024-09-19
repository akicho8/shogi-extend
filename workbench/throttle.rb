require "./setup"

throttle = Throttle.new(expires_in: 0.2, delayed_again: false)
throttle.reset
throttle.call             # => true
sleep(0.1)
throttle.call             # => false
sleep(0.1)
throttle.call             # => true

throttle = Throttle.new(expires_in: 0.2, delayed_again: true)
throttle.reset
throttle.call             # => true
sleep(0.1)
throttle.call             # => false
sleep(0.1)
throttle.call             # => false
