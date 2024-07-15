require "./setup"
GoogleApi::ExpirationTracker.delete_all
GoogleApi::ExpirationTracker.count          # => 0
GoogleApi::Facade.new(rows: [{id: 1}]).call # => "https://docs.google.com/spreadsheets/d/1fvp4AWulCdcqdnYUX5LJYsdGg_37heG3_Cs3eTIujNs/edit"
GoogleApi::ExpirationTracker.count          # => 1
GoogleApi::ExpirationTracker.destroy_all
GoogleApi::ExpirationTracker.count          # => 0
# >> 2024-07-15T03:33:22.846Z pid=58380 tid=1bxs INFO: Sidekiq 7.1.6 connecting to Redis with options {:size=>10, :pool_name=>"internal", :url=>"redis://localhost:6379/4"}
