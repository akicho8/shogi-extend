module Tsl
  class User < ApplicationRecord
    has_many :memberships, dependent: :destroy, inverse_of: :user # 対局時の情報(複数)
    has_many :leagues, through: :memberships                      # 対局(複数)

    def name_with_age
      s = ""

      s += "#{memberships.count} - " # 在籍N期

      s += name

      if first_age && last_age
        s += "(#{first_age}-#{last_age})"
      end

      # プロ？
      if break_through?
        s += " ★"
      end

      s
    end

    def break_through?
      memberships.any? { |e| e.result_key == "昇段" }
    end

    # シーズン generation を含むこれまでの在籍回数
    def seat_count(generation)
      memberships.joins(:league).where(Tsl::League.arel_table[:generation].lteq(generation)).count
    end
  end
end
