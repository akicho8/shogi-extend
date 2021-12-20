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

SlackAgent.notify(body: "ok")   # => #<SlackAgentNotifyJob:0x00007fc106f8ada8 @arguments=[{:channel=>"#shogi-extend-development", :text=>"▫ 19986 w0 20:02:55.767ok"}], @job_id="64b4bd7c-aebb-4622-9b22-eb03b922b59c", @queue_name="default", @priority=nil, @executions=0, @exception_executions={}, @timezone="Tokyo", @scheduled_at=1639998175.913493, @provider_job_id="35a1b8b820cc86dea1cf6759">
