require File.expand_path('../../config/environment', __FILE__)

# rails dev:cache で Rails.cache を有効にすること

obj = ExcessiveMeasure.new(key: "foo", run_per_second: 2, expires_in: 2)
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

SlackAgent.notify(body: "ok")   # => #<SlackAgentNotifyJob:0x00007fd654d93c80 @arguments=[{:channel=>"#shogi-extend-development", :text=>"▫ 27241 w0 14:47:27.031ok"}], @job_id="7c624ab5-a653-4773-a926-a567be331920", @queue_name="default", @priority=nil, @executions=0, @exception_executions={}, @timezone="Tokyo", @scheduled_at=1640324847.032952, @provider_job_id="c1ad8d04bc72adfafce452ba">
