# -*- coding: utf-8 -*-

# == Schema Information ==
#
# ライブラリ (kiwi_bananas as Kiwi::Banana)
#
# |-----------------------+----------------+-------------+---------------------+------+-------|
# | name                  | desc           | type        | opts                | refs | index |
# |-----------------------+----------------+-------------+---------------------+------+-------|
# | id                    | ID             | integer(8)  | NOT NULL PK         |      |       |
# | key                   | キー           | string(255) | NOT NULL            |      | A!    |
# | user_id               | 所有者         | integer(8)  | NOT NULL            |      | C     |
# | folder_id             | 公開設定       | integer(8)  | NOT NULL            |      | D     |
# | lemon_id              | 動画ファイル   | integer(8)  | NOT NULL            |      | B!    |
# | title                 | タイトル       | string(100) | NOT NULL            |      |       |
# | description           | 説明           | text(65535) | NOT NULL            |      |       |
# | thumbnail_pos         | サムネ位置(秒) | float(24)   | NOT NULL            |      |       |
# | banana_messages_count | コメント数     | integer(4)  | DEFAULT(0) NOT NULL |      | E     |
# | access_logs_count     | アクセス数     | integer(4)  | DEFAULT(0) NOT NULL |      | F     |
# | created_at            | 作成日時       | datetime    | NOT NULL            |      |       |
# | updated_at            | 更新日時       | datetime    | NOT NULL            |      |       |
# |-----------------------+----------------+-------------+---------------------+------+-------|
#
# - Remarks ----------------------------------------------------------------------
# [Warning: Need to add relation] Kiwi::Banana モデルに belongs_to :folder を追加しよう
# [Warning: Need to add relation] Kiwi::Banana モデルに belongs_to :lemon を追加しよう
# [Warning: Need to add relation] Kiwi::Banana モデルに belongs_to :user を追加しよう
# --------------------------------------------------------------------------------

module Kiwi
  class Banana < ApplicationRecord
    include BasicMethods
    include FolderMethods
    include InfoMethods
    include JsonStructMethods
    include BananaMessageMethods
    include AccessLogMethods
    include MockMethods
    include DefaultImportMethods
    include ChoreMethods
  end
end
