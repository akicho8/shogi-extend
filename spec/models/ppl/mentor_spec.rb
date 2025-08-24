# -*- coding: utf-8 -*-

# == Schema Information ==
#
# Mentor (ppl_mentors as Ppl::Mentor)
#
# |-------------+-------------+-------------+---------------------+------+-------|
# | name        | desc        | type        | opts                | refs | index |
# |-------------+-------------+-------------+---------------------+------+-------|
# | id          | ID          | integer(8)  | NOT NULL PK         |      |       |
# | name        | Name        | string(255) | NOT NULL            |      | A!    |
# | users_count | Users count | integer(4)  | DEFAULT(0) NOT NULL |      |       |
# | created_at  | 作成日時    | datetime    | NOT NULL            |      |       |
# | updated_at  | 更新日時    | datetime    | NOT NULL            |      |       |
# |-------------+-------------+-------------+---------------------+------+-------|

require "rails_helper"

RSpec.describe Ppl::Mentor, type: :model do
  it "counter_cache" do
    Ppl.setup_for_workbench
    Ppl::SeasonKeyVo["5"].update_by_records({ mentor: "親", name: "子", result_key: "維持", })
    assert { Ppl::Mentor["親"].users_count == 1 }
  end
end
