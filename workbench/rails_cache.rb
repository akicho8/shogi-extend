require "#{__dir__}/setup"
Rails.cache.redis               # => #<ConnectionPool:0x000000012727e200 @size=5, @timeout=5, @auto_reload_after_fork=true, @available=#<ConnectionPool::TimedStack:0x000000012727e1b0 @create_block=#<Proc:0x0000000127251188 /opt/rbenv/versions/3.4.2/lib/ruby/gems/3.4.0/gems/activesupport-8.0.2/lib/active_support/cache/redis_cache_store.rb:153>, @created=0, @que=[], @max=5, @mutex=#<Thread::Mutex:0x0000000127251110>, @resource=#<Thread::ConditionVariable:0x00000001272510c0>, @shutdown_block=nil>, @key=:"pool-4224", @key_count=:"pool-4224-count">
tp((Rails.cache.methods - "".methods).sort)
# >> |-----------------------------------------|
# >> | cleanup                                 |
# >> | decrement                               |
# >> | delete_matched                          |
# >> | delete_multi                            |
# >> | exist?                                  |
# >> | fetch                                   |
# >> | fetch_multi                             |
# >> | increment                               |
# >> | logger                                  |
# >> | logger=                                 |
# >> | max_key_bytesize                        |
# >> | middleware                              |
# >> | mute                                    |
# >> | new_entry                               |
# >> | options                                 |
# >> | raise_on_invalid_cache_expiration_time  |
# >> | raise_on_invalid_cache_expiration_time= |
# >> | read                                    |
# >> | read_multi                              |
# >> | redis                                   |
# >> | silence                                 |
# >> | silence!                                |
# >> | silence?                                |
# >> | stats                                   |
# >> | with_local_cache                        |
# >> | write                                   |
# >> | write_multi                             |
# >> |-----------------------------------------|
