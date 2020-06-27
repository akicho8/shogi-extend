# -*- coding: utf-8 -*-
# == Schema Information ==
#
# Profile (profiles as Profile)
#
# |-------------+-------------------+-------------+-------------+------------+-------|
# | name        | desc              | type        | opts        | refs       | index |
# |-------------+-------------------+-------------+-------------+------------+-------|
# | id          | ID                | integer(8)  | NOT NULL PK |            |       |
# | user_id     | User              | integer(8)  | NOT NULL    | => User#id | A!    |
# | created_at  | 作成日時          | datetime    | NOT NULL    |            |       |
# | updated_at  | 更新日時          | datetime    | NOT NULL    |            |       |
# | description | 自己紹介          | string(255) | NOT NULL    |            |       |
# | twitter_key | Twitterアカウント | string(255) | NOT NULL    |            |       |
# |-------------+-------------------+-------------+-------------+------------+-------|
#
#- Remarks ----------------------------------------------------------------------
# User.has_many :actb_room_messages
#--------------------------------------------------------------------------------

class FixUserName < ActiveRecord::Migration[6.0]
  def up
    User.find_each do |e|
      e.name = e.name.remove("(絵文字)").strip
      begin
        a = Mail::Address.new(e.name)
        if a.domain.to_s.match?(/\.(com|jp)\z/)
          e.name = a.local
        end
      rescue Mail::Field::IncompleteParseError
      end
      e.save!
    end
  end
end
