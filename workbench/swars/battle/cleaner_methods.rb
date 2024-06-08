require "./setup"
# sql
Swars::Battle.limit(nil).old_only(50.days).count          # => 108916
Swars::Battle.limit(nil).pro_only.count                   # => 17446
Swars::Battle.limit(nil).pro_except.count                 # => 1654737
Swars::Battle.limit(nil).ban_only.count                   # => 4620
Swars::Battle.limit(nil).ban_except.count                 # => 1667563
Swars::Battle.limit(nil).user_only("SiroChannel").count   # => 5
Swars::Battle.limit(nil).user_except("SiroChannel").count # => 1672178
Swars::Battle.limit(nil).xmode_only("指導").count         # => 17460
Swars::Battle.limit(nil).xmode_except("指導").count       # => 1654723
Swars::Battle.limit(nil).coaching_only.count              # => 17460
Swars::Battle.limit(nil).coaching_except.count            # => 1654723

Swars::Battle.scope_for_cleaner1.count                    # => 1518429
Swars::Battle.scope_for_cleaner2.count                    # =>   76239
