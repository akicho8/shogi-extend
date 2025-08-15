require "./setup"
sql
Swars::Battle.limit(nil).old_only(50.days).count          # =>
Swars::Battle.limit(nil).pro_only.count                   # =>
Swars::Battle.limit(nil).pro_except.count                 # =>
Swars::Battle.limit(nil).ban_only.count                   # =>
Swars::Battle.limit(nil).ban_except.count                 # =>
Swars::Battle.limit(nil).user_only("SiroChannel").count   # =>
Swars::Battle.limit(nil).user_except("SiroChannel").count # =>
Swars::Battle.limit(nil).xmode_only("指導").count         # =>
Swars::Battle.limit(nil).xmode_except("指導").count       # =>
Swars::Battle.limit(nil).coaching_only.count              # =>
Swars::Battle.limit(nil).coaching_except.count            # =>
Swars::Battle.destroyable_n.count                    # =>
Swars::Battle.destroyable_s.count                    # =>
