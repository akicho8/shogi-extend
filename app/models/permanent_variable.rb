# -*- coding: utf-8 -*-

# == Schema Information ==
#
# Permanent variable (permanent_variables as PermanentVariable)
#
# |------------+----------+-------------+-------------+------+-------|
# | name       | desc     | type        | opts        | refs | index |
# |------------+----------+-------------+-------------+------+-------|
# | id         | ID       | integer(8)  | NOT NULL PK |      |       |
# | key        | キー     | string(255) | NOT NULL    |      | A!    |
# | value      | Value    | json        | NOT NULL    |      |       |
# | created_at | 作成日時 | datetime    | NOT NULL    |      |       |
# | updated_at | 更新日時 | datetime    | NOT NULL    |      |       |
# |------------+----------+-------------+-------------+------+-------|

# インターフェイスはこの2つだけ
#
# |----------+-------------------------------------------|
# | 内容     | コード                                    |
# |----------+-------------------------------------------|
# | 書き込み | PermanentVariable["A"].write({foo: 1})    |
# | 読み出し | PermanentVariable["A"].read # => {foo: 1} |
# |----------+-------------------------------------------|
#
class PermanentVariable < ApplicationRecord
  scope :key_only, -> key { where(key: key) }

  class << self
    def [](key)
      if record = find_by(key: key)
        if v = record.value
          if v.kind_of?(Hash)
            v = v.deep_symbolize_keys
          end
        end
        v
      end
    end

    def []=(key, value)
      record = find_or_initialize_by(key: key)
      record.update!(value: value)
    end
  end

  before_validation do
    self.value ||= {}
  end

  with_options presence: true do
    validates :key
  end

  if Rails.env.local?
    after_create_commit do
      AppLog.info(subject: "[変数永続化][#{key}]", body: value.to_t(truncate: nil))
    end
  end
end
