# -*- coding: utf-8 -*-
# == Schema Information ==
#
# アーカイブ (kiwi_books as Kiwi::Book)
#
# |---------------------+---------------------+-------------+---------------------+--------------+-------|
# | name                | desc                | type        | opts                | refs         | index |
# |---------------------+---------------------+-------------+---------------------+--------------+-------|
# | id                  | ID                  | integer(8)  | NOT NULL PK         |              |       |
# | key                 | キー                | string(255) | NOT NULL            |              | A!    |
# | user_id             | User                | integer(8)  | NOT NULL            | => ::User#id | C     |
# | folder_id           | Folder              | integer(8)  | NOT NULL            |              | D     |
# | lemon_id            | 動画ファイル        | integer(8)  | NOT NULL            |              | B!    |
# | title               | タイトル            | string(100) | NOT NULL            |              |       |
# | description         | 説明                | text(65535) | NOT NULL            |              |       |
# | thumbnail_pos       | Thumbnail pos       | float(24)   | NOT NULL            |              |       |
# | book_messages_count | Book messages count | integer(4)  | DEFAULT(0) NOT NULL |              | E     |
# | access_logs_count   | Access logs count   | integer(4)  | DEFAULT(0) NOT NULL |              | F     |
# | created_at          | 作成日時            | datetime    | NOT NULL            |              |       |
# | updated_at          | 更新日時            | datetime    | NOT NULL            |              |       |
# |---------------------+---------------------+-------------+---------------------+--------------+-------|
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
    include JsonStructMethods
    include BookMessageMethods
    include AccessLogMethods
    include MockMethods
  end
end
