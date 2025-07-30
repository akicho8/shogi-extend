# -*- coding: utf-8 -*-

# == Schema Information ==
#
# Aggregate cache (aggregate_caches as AggregateCache)
#
# |------------------+------------------+-------------+-------------+------+-------|
# | name             | desc             | type        | opts        | refs | index |
# |------------------+------------------+-------------+-------------+------+-------|
# | id               | ID               | integer(8)  | NOT NULL PK |      |       |
# | group_name       | Group name       | string(255) | NOT NULL    |      | A! B  |
# | generation       | Generation       | integer(4)  | NOT NULL    |      | A! C  |
# | aggregated_value | Aggregated value | json        | NOT NULL    |      |       |
# | created_at       | 作成日時         | datetime    | NOT NULL    |      |       |
# | updated_at       | 更新日時         | datetime    | NOT NULL    |      |       |
# |------------------+------------------+-------------+-------------+------+-------|

# インターフェイスはこの2つだけ
#
# |----------+----------------------------------------|
# | 内容     | コード                                 |
# |----------+----------------------------------------|
# | 書き込み | AggregateCache["A"].write({foo: 1})    |
# | 読み出し | AggregateCache["A"].read # => {foo: 1} |
# |----------+----------------------------------------|
#
# 疑問: これなんで世代を持つようにしたんだっけ？？？
#
class AggregateCache < ApplicationRecord
  scope :group_only, -> group_name { where(group_name: group_name) } # group_name で絞る
  scope :old_only, -> { where.not(generation: latest_generation) }   # 最後の世代を除くすべて

  class << self
    # すべての参照はここから進める
    def [](group_name)
      group_only(group_name)
    end

    # まとめてDBに入れる
    def write(value = nil, &block)
      if value && block_given?
        raise ArgumentError, "引数とブロックを同時に指定しないでください"
      end
      if block_given?
        value = Benchmarker.call { yield }
      end
      value ||= {}
      create!(generation: next_generation, aggregated_value: value)
      old_only.destroy_all
      value
    end

    # なければブロックの結果を書き込んで読み出す
    def fetch(&block)
      value = read
      unless value
        write { yield }
        value = read
      end
      value
    end

    # DBから最新を取り出す
    def read
      if value = where(generation: latest_generation).pick(:aggregated_value).presence
        { value: value }.deep_symbolize_keys[:value]
      end
    end

    # すでに DB に入っている最新の世代
    def latest_generation
      order(generation: :desc).pick(:generation)
    end

    private

    # 次のまだ DB に入っていない世代
    def next_generation
      latest_generation&.next || 0
    end
  end

  before_validation on: :create do
    self.group_name ||= "main"
    self.generation ||= 0
    self.aggregated_value ||= {}
  end

  with_options presence: true do
    validates :group_name
    validates :generation
  end

  after_create_commit do
    AppLog.info(subject: "[#{group_name}][#{generation}] 一次集計完了", body: aggregated_value.to_t(truncate: 80))
  end
end
