#!/usr/bin/env ruby
require File.expand_path('../../config/environment', __FILE__)

Rails.cache.redis               # => #<Redis client v4.1.3 for redis://127.0.0.1:6379/1>

tp((Rails.cache.methods - "".methods).sort)
# >> |------------------|
# >> | cleanup          |
# >> | decrement        |
# >> | delete_matched   |
# >> | exist?           |
# >> | fetch            |
# >> | fetch_multi      |
# >> | increment        |
# >> | logger           |
# >> | logger=          |
# >> | max_key_bytesize |
# >> | mget_capable?    |
# >> | middleware       |
# >> | mset_capable?    |
# >> | mute             |
# >> | options          |
# >> | read             |
# >> | read_multi       |
# >> | redis            |
# >> | redis_options    |
# >> | silence          |
# >> | silence!         |
# >> | silence?         |
# >> | with_local_cache |
# >> | write            |
# >> | write_multi      |
# >> |------------------|
