# -*- coding: utf-8 -*-
# == Schema Information ==
#
# Emotion folder (actb_emotion_folders as Actb::EmotionFolder)
#
# |------------+----------+-------------+-------------+------+-------|
# | name       | desc     | type        | opts        | refs | index |
# |------------+----------+-------------+-------------+------+-------|
# | id         | ID       | integer(8)  | NOT NULL PK |      |       |
# | key        | キー     | string(255) | NOT NULL    |      |       |
# | position   | 順序     | integer(4)  | NOT NULL    |      | A     |
# | created_at | 作成日時 | datetime    | NOT NULL    |      |       |
# | updated_at | 更新日時 | datetime    | NOT NULL    |      |       |
# |------------+----------+-------------+-------------+------+-------|

module Actb
  # rails r "tp Actb::EmotionFolder"
  class EmotionFolder < ApplicationRecord
    include MemoryRecordBind::Basic

    has_many :emotions, dependent: :destroy
  end
end
