require File.expand_path('../../config/environment', __FILE__)

# rails dev:cache で Rails.cache を有効にすること

obj = ExcessiveMeasure.new(key: "foo", run_per_second: 2)
obj.reset
4.times.collect { obj.wait_value_for_job } # => [0, 0, 1, 1]
4.times.collect { obj.wait_value_for_job } # => [2, 2, 3, 3]
sleep(4)
4.times.collect { obj.wait_value_for_job } # => [0, 0, 1, 1]

obj = ExcessiveMeasure.new
obj.wait_value_for_job # => 0
obj.wait_value_for_job # => 1
obj.reset
obj.wait_value_for_job # => 0

SlackAgent.notify(body: "ok")   # => #<SlackAgentNotifyJob:0x00007fe2992a4d50 @arguments=[{:channel=>"#shogi-extend-development", :text=>"2 W0 09:57:28.285【】ok"}], @job_id="a4b67090-7fdd-4247-9f9c-e72f08357cb5", @queue_name="default", @priority=nil, @executions=0, @exception_executions={}, @timezone="Tokyo", @scheduled_at=1638665848.358565, @provider_job_id="bcb7a2c96b89ea6cd179eef3">
