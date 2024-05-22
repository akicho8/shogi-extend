# frozen-string-literal: true

module Swars
  module UserStat
    class PieceStat < Base
      delegate *[
        :ids_scope,
      ], to: :@user_stat

      def to_chart
        if denominator.positive?
          list = []
          # 表面の駒
          Bioshogi::Piece.each do |e|
            list << {
              :name  => e.any_name(false),
              :value => ratio_of("#{e.sfen_char}0"),
            }
          end
          # 裏面の駒
          Bioshogi::Piece.each do |e|
            if e.promotable
              list << {
                :name  => e.any_name(true, char_type: :single_char), # 1文字の漢字にする。例えば「成銀」ではなく「全」,
                :value => ratio_of("#{e.sfen_char}1"),
              }
            end
          end
          list
        end
      end

      def ratio_of(key)
        counts_hash[key].fdiv(denominator)
      end

      def denominator
        @denominator ||= counts_hash.values.sum
      end

      # membership.membership_extra.used_piece_counts # => {"B0"=>7, "G0"=>4, "K0"=>6, ... }
      # となっているので memberships ぶんだけ加算したハッシュを作る
      def counts_hash
        @counts_hash ||= yield_self do
          h = Hash.new(0)
          s = ids_scope
          s = s.includes(:membership_extra) # SQLで参照しているわけではないので JOIN する必要はないが includes は重要
          s.each do |e|
            if e = e.membership_extra
              h.update(e.used_piece_counts) { |_, a, b| a + b } # MySQL で hash を合体できれば置き換える
            end
          end
          h
        end
      end
    end
  end
end
