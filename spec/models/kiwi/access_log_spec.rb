# -*- coding: utf-8 -*-
# == Schema Information ==
#
# Access log (kiwi_access_logs as Kiwi::AccessLog)
#
# |------------+----------+------------+-------------+--------------+-------|
# | name       | desc     | type       | opts        | refs         | index |
# |------------+----------+------------+-------------+--------------+-------|
# | id         | ID       | integer(8) | NOT NULL PK |              |       |
# | user_id    | User     | integer(8) |             | => ::User#id | A     |
# | banana_id  | Banana   | integer(8) | NOT NULL    |              | B     |
# | created_at | 作成日時 | datetime   | NOT NULL    |              |       |
# |------------+----------+------------+-------------+--------------+-------|
#
#- Remarks ----------------------------------------------------------------------
# User.has_one :profile
#--------------------------------------------------------------------------------

require "rails_helper"

module Kiwi
  RSpec.describe AccessLog, type: :model do
    include KiwiSupport

    it "ログインユーザーのアクセス" do
      assert { access_log1.user }
      assert { access_log1.banana }

      assert { access_log1.user.kiwi_access_logs == [access_log1] }
      assert { access_log1.user.kiwi_access_bananas == [banana1]      }
      assert { access_log1.user.kiwi_access_logs.uniq_histories == [banana1] }

      assert { access_log1.banana.access_logs == [access_log1]      }
      assert { access_log1.banana.access_logs_count == 1            }
      assert { access_log1.banana.access_log_users == [user1]       }

      assert { access_log1.banana.access_logs == [access_log1]      }
      assert { access_log1.banana.access_log_users == [user1]       }
    end

    it "非ログインユーザーのアクセス" do
      assert { access_log1 = banana1.access_logs.create! }
    end
  end
end
