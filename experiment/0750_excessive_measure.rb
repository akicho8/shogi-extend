require File.expand_path('../../config/environment', __FILE__)

# rails dev:cache で Rails.cache を有効にすること

obj = ExcessiveMeasure.new(key: "foo", run_per_second: 2, expires_in: 2)
obj.reset
4.times.collect { obj.wait_value_for_job } # => [0, 0, 1, 1]
4.times.collect { obj.wait_value_for_job } # => [2, 2, 2, 2]
sleep(4)
4.times.collect { obj.wait_value_for_job } # => [0, 0, 1, 1]

obj = ExcessiveMeasure.new
obj.wait_value_for_job # => 0
obj.wait_value_for_job # => 1
obj.reset
obj.wait_value_for_job # => 0

SlackAgent.notify(body: "ok")   # => #<SlackAgentNotifyJob:0x00007fa5bb1822a8 @arguments=[{:channel=>"#shogi-extend-development", :text=>"▫ 27246 w0 14:57:18.886ok"}], @job_id="52829a66-e01a-475c-b3e6-45a6047a83f7", @queue_name="default", @priority=nil, @executions=0, @exception_executions={}, @timezone="Tokyo", @scheduled_at=1640325438.9503071, @provider_job_id="ead3f42c6bbdb94bd3f28dce">
