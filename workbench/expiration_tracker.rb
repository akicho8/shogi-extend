require "./setup"
sql
ExpirationTracker.old_only(50.days).cleaner.call
