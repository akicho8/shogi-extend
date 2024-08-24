# インターフェイスはこの2つだけ
#
# 書き込み
# AggregateCache["A"].write("X")
#
# 読み出し
# AggregateCache["A"].read # => "X"
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
    def write(aggregated_value = nil)
      create!(generation: next_generation, aggregated_value: aggregated_value)
      old_only.destroy_all
    end

    # DBから最新を取り出す
    def read
      where(generation: latest_generation).pick(:aggregated_value).presence.try { deep_symbolize_keys }
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
    AppLog.important(subject: "[#{group_name}][#{generation}] 一次集計完了", body: aggregated_value.to_t(truncate: 80))
  end
end
