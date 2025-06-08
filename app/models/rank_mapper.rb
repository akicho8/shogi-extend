# RankMapper.ranks([])                       # => []
# RankMapper.ranks([nil, 1]) rescue $!.class # => ArgumentError
# RankMapper.ranks([5, 5])                   # => [0, 0]
# RankMapper.ranks([7, 6, 6, 5, 5])          # => [4, 2, 2, 0, 0]
# RankMapper.ranks([2, 3, 4], base_rank: 5)  # => [5, 6, 7]
# RankMapper.ranks([-5, -4, -4, -3])         # => [0, 1, 1, 3]
class RankMapper
  class << self
    def ranks(...)
      new(...).ranks
    end
  end

  def initialize(values, options = {})
    @options = options
    @values = values
  end

  def ranks
    @ranks ||= @values.collect { |v| map[v] }
  end

  def to_a
    ranks
  end

  def to_h
    map
  end

  private

  def map
    @map ||= {}.tap do |map|
      sorted = @values.each_with_index.sort_by { |v, _| v }
      sorted.each_with_index do |(v, _), i|
        map[v] ||= base_rank + i
      end
    end
  end

  def base_rank
    @options[:base_rank] || 0
  end
end
