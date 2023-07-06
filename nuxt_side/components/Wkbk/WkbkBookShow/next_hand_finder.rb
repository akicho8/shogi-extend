# 相手の指し手を求める方法
class NextHandFinder
  def initialize(list_of_moves, inputs, options = {})
    @options = {
      behavior: :most_long,
    }.merge(options)

    @list_of_moves = list_of_moves
    @inputs = inputs
  end

  def call
    av = @list_of_moves.collect(&method(:next_hand))
    av = av.compact
    unless av.empty?
      case @options[:behavior]
      when :first
        v = av.first
      when :last
        v = av.last
      when :most_short
        v = most_short_or_most_long(av, :first)
      when :most_long
        v = most_short_or_most_long(av, :last)
      when :random
        v = av.sample
      else
        raise "must not happen"
      end
      v[:next]
    end
  end

  private

  def most_short_or_most_long(av, method)
    distance = av.sort_by { |e| e[:distance] }.public_send(method)[:distance]
    av.find_all { |e| e[:distance] == distance }.sample
  end

  def next_hand(moves)
    if moves.take(@inputs.size) == @inputs # 途中まで正解していたか？
      size = @inputs.size.next
      if size <= moves.size              # その次の手があるか？
        {
          :next     => moves.take(size), # 入力が ["a"] なら ["a", "b"]
          :distance => moves.size,       # 7手詰なら7
        }
      end
    end
  end
end

NextHandFinder.new([%w(a b c d)], %w()).call          # => ["a"]
NextHandFinder.new([%w(a b c d)], %w(a)).call         # => ["a", "b"]
NextHandFinder.new([%w(a b c d)], %w(a b)).call       # => ["a", "b", "c"]
NextHandFinder.new([%w(a b c d)], %w(a b c)).call     # => ["a", "b", "c", "d"]
NextHandFinder.new([%w(a b c d)], %w(a b c d)).call   # => nil
NextHandFinder.new([%w(a b c d)], %w(a b c d e)).call # => nil
NextHandFinder.new([%w(a b c d)], %w(x)).call         # => nil
NextHandFinder.new([%w(a b c d)], %w(a x)).call       # => nil

NextHandFinder.new([%w(a x), %w(a y z)], %w(a), behavior: :first).call      # => ["a", "x"]
NextHandFinder.new([%w(a x), %w(a y z)], %w(a), behavior: :last).call       # => ["a", "y"]
NextHandFinder.new([%w(a x), %w(a y z)], %w(a), behavior: :most_short).call # => ["a", "x"]
NextHandFinder.new([%w(a x), %w(a y z)], %w(a), behavior: :most_long).call  # => ["a", "y"]
NextHandFinder.new([%w(a x), %w(a y z)], %w(a), behavior: :random).call     # => ["a", "y"]
