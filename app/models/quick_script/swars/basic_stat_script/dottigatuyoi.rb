# QuickScript::Swars::BasicStatScript::PrimaryAggregator.new.main_scope.count
# QuickScript::Swars::BasicStatScript::PrimaryAggregator.new.main_scope.joins(:taggings => :tag).count
# QuickScript::Swars::BasicStatScript::PrimaryAggregator.new.main_scope.joins(:taggings => :tag).joins(:judge).count
# .group("tags.name").group("judges.key").count
# Swars::Membership.joins(:taggings).count
# Swars::Membership.joins(:taggings => :tag).count

class QuickScript::Swars::BasicStatScript
  class Dottigatuyoi
    attr_accessor :base

    def initialize(base)
      @base = base
    end

    def cache_write
      AggregateCache[self.class.name].write(__counts_hash)
    end

    def cache_clear
      AggregateCache[self.class.name].destroy_all
    end

    def call
      [
        {
          "▲勝率" => ratio_by(:black).try { "%.3f %%" % (self * 100) },
          "△勝率" => ratio_by(:white).try { "%.3f %%" % (self * 100) },
          "▲勝数" => count_by(:black),
          "△勝数" => count_by(:white),
          "分母"   => denominator,
        },
      ]
    end

    def to_component
      base.simple_table(call, always_table: true)
    end

    def count_by(location_key)
      counts_hash[:"#{location_key}_win"] || 0
    end

    def ratio_by(location_key)
      denominator = count_by(:black) + count_by(:white)
      if denominator.positive?
        count = count_by(location_key)
        count.fdiv(denominator)
      end
    end

    def denominator
      count_by(:black) + count_by(:white)
    end

    def main_scope
      base.params[:scope] || ::Swars::Membership.all
    end

    def counts_hash
      @counts_hash ||= AggregateCache[self.class.name].read || __counts_hash
    end

    def __counts_hash
      s = main_scope
      s = s.joins(:battle)
      s = s.merge(::Swars::Battle.imode_eq(:sprint))
      s = s.joins(:location)
      s = s.joins(:judge)
      s = s.group("locations.key")
      s = s.group("judges.key")
      # JSON化するときキーを配列にはできないため文字列化する
      s.count.transform_keys { |e| e.join("_").to_sym }
    end
  end
end
