require "./setup"
GoogleApi::ExpirationTracker.delete_all
GoogleApi::ExpirationTracker.count          # => 0
GoogleApi::Facade.new(rows: [{id: 1}]).call # => "https://docs.google.com/spreadsheets/d/1M0VsErGIZQpezy4lOUEmZvJaLJyhhBilGrhygePGnJI/edit"
GoogleApi::ExpirationTracker.count          # => 1
GoogleApi::ExpirationTracker.destroy_all
GoogleApi::ExpirationTracker.count          # => 0
# >> 2025-03-17T08:23:03.128Z pid=16732 tid=e9g INFO: Sidekiq 7.3.9 connecting to Redis with options {size: 10, pool_name: "internal", url: "redis://localhost:6379/4"}
