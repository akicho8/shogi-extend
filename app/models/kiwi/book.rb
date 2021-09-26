# -*- coding: utf-8 -*-
# == Schema Information ==
#
# Book (kiwi_books as Kiwi::Book)
#
# |-------------+--------------------+-------------+-------------+--------------+-------|
# | name        | desc               | type        | opts        | refs         | index |
# |-------------+--------------------+-------------+-------------+--------------+-------|
# | id          | ID                 | integer(8)  | NOT NULL PK |              |       |
# | key         | ユニークなハッシュ | string(255) | NOT NULL    |              | A!    |
# | user_id     | User               | integer(8)  | NOT NULL    | => ::User#id | B     |
# | folder_id   | Folder             | integer(8)  | NOT NULL    |              | C     |
# | lemon_id    | Lemon              | integer(8)  | NOT NULL    |              | D     |
# | title       | タイトル           | string(100) | NOT NULL    |              |       |
# | description | 説明               | text(65535) | NOT NULL    |              |       |
# | created_at  | 作成日時           | datetime    | NOT NULL    |              |       |
# | updated_at  | 更新日時           | datetime    | NOT NULL    |              |       |
# |-------------+--------------------+-------------+-------------+--------------+-------|
#
#- Remarks ----------------------------------------------------------------------
# User.has_one :profile
#--------------------------------------------------------------------------------

require "nkf"

module Kiwi
  class Book < ApplicationRecord
    include BasicMethods
    include FolderMethods
    include InfoMethods
    include AvatarMethods
    include JsonStructMethods
    include MockMethods
    include BookMessageMethods
  end
end
