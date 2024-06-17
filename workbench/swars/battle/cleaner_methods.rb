require "./setup"
# sql
Swars::Battle.limit(nil).old_only(50.days).count          # => 141426
Swars::Battle.limit(nil).pro_only.count                   # => 17535
Swars::Battle.limit(nil).pro_except.count                 # => 1780318
Swars::Battle.limit(nil).ban_only.count                   # => 4600
Swars::Battle.limit(nil).ban_except.count                 # => 1793253
Swars::Battle.limit(nil).user_only("SiroChannel").count   # => 5
Swars::Battle.limit(nil).user_except("SiroChannel").count # => 1797848
Swars::Battle.limit(nil).xmode_only("指導").count         # => 17574
Swars::Battle.limit(nil).xmode_except("指導").count       # => 1780279
Swars::Battle.limit(nil).coaching_only.count              # => 17574
Swars::Battle.limit(nil).coaching_except.count            # => 1780279

Swars::Battle.scope_for_cleaner1.count                    # => 1683011
Swars::Battle.scope_for_cleaner2.count                    # => 32571
