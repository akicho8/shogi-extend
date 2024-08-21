# rails r 'Swars::TagJudgeItem.create_new_generation_items'
module Swars
  class TagJudgeItem < ApplicationRecord
    scope :old_only_scope, -> { where.not(generation: db_latest_generation) }

    class << self
      def db_latest_generation
        order(generation: :desc).pick(:generation)
      end

      def next_generation
        if generation = db_latest_generation
          generation.next
        else
          0
        end
      end

      # DBに入れるためのデータを作る
      def counts_hash_calc(options = {})
        s = options[:scope] || Membership.all
        s = s.joins(:battle).where(Battle.arel_table[:turn_max].gteq(Config.seiritsu_gteq))
        s = s.joins(:taggings => :tag)
        s = s.joins(:judge)
        s = s.group("tags.name")
        s = s.group("judges.key")

        # { "棒銀" => { win_count: 2, lose_count: 3, draw_count: 1 } } の形に変換する

        hv = {}
        s.count.each do |(tag_name, judge_key), count|
          hv[tag_name] ||= { win_count: 0, lose_count: 0, draw_count: 0 }
          hv[tag_name][:"#{judge_key}_count"] = count
        end

        hv
      end

      # まとめてDBに入れる
      def create_new_generation_items(options = {})
        hv = counts_hash_calc(options)
        transaction do
          generation = next_generation
          hv.each do |tag_name, e|
            create!({
                :generation => generation,
                :tag_name   => tag_name,
                :win_count  => e[:win_count],
                :lose_count => e[:lose_count],
                :draw_count => e[:draw_count],
                :freq_count => e[:win_count] + e[:lose_count] + e[:draw_count],
              })
          end
          old_only_scope.destroy_all
        end
      end

      # DBから最新を取り出す
      def db_latest_items
        where(generation: db_latest_generation)
      end

      def db_latest_created_at
        where(generation: db_latest_generation).pick(:created_at)
      end
    end

    before_validation on: :create do
      self.generation ||= 0
      self.win_count ||= 0
      self.lose_count ||= 0
      self.draw_count ||= 0
      self.freq_count ||= 0
    end

    with_options presence: true do
      validates :generation
      validates :tag_name
      validates :win_count
      validates :lose_count
      validates :draw_count
      validates :freq_count
    end

    def win_lose_count
      win_count + lose_count
    end
  end
end
