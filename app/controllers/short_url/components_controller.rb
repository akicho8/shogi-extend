# -*- coding: utf-8 -*-
# == Schema Information ==
#
# Component (short_url_components as ShortUrl::Component)
#
# |-------------------+-------------------+--------------+---------------------+------+-------|
# | name              | desc              | type         | opts                | refs | index |
# |-------------------+-------------------+--------------+---------------------+------+-------|
# | id                | ID                | integer(8)   | NOT NULL PK         |      |       |
# | key               | キー              | string(255)  | NOT NULL            |      | A!    |
# | original_url      | Original url      | string(2048) | NOT NULL            |      |       |
# | access_logs_count | Access logs count | integer(4)   | DEFAULT(0) NOT NULL |      |       |
# | created_at        | 作成日時          | datetime     | NOT NULL            |      |       |
# | updated_at        | 更新日時          | datetime     | NOT NULL            |      |       |
# |-------------------+-------------------+--------------+---------------------+------+-------|

module ShortUrl
  class ComponentsController < ApplicationController
    skip_before_action :user_name_required
    skip_forgery_protection

    def show
      Component.show_action(self)
    end
  end
end
