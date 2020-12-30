# -*- coding: utf-8 -*-
# == Schema Information ==
#
# Question (ts_master_questions as TsMaster::Question)
#
# |----------+------+-------------+-------------+------+-------|
# | name     | desc | type        | opts        | refs | index |
# |----------+------+-------------+-------------+------+-------|
# | id       | ID   | integer(8)  | NOT NULL PK |      |       |
# | sfen     | Sfen | string(255) | NOT NULL    |      |       |
# | mate     | Mate | integer(4)  | NOT NULL    |      | A     |
# | position | 順序 | integer(4)  | NOT NULL    |      | B     |
# |----------+------+-------------+-------------+------+-------|

module TsMaster
  class Question < ApplicationRecord
    class << self
      # rails r 'TsMaster::Question.setup(mate: 3, max: 100)'
      def setup(options = {})
        options = {
          max: default_max,
          mate: [3, 5, 7, 9, 11],
          reset: Rails.env.development? || Rails.env.test?,
        }.merge(options)

        Array(options[:mate]).each do |mate|
          mate_import(mate, options)
        end
      end

      private def mate_import(mate, options = {})
        if options[:reset]
          all.mate_eq(mate).destroy_all
        end
        open(source_file(mate)) do |f|
          n = 0
          f.each(chomp: true) do |e|
            if options[:max] && n >= options[:max]
              break
            end
            create!(sfen: e, mate: mate)
            n += 1
            if n.modulo(100).zero?
              p [mate, n]
            end
          end
        end
      end

      private def source_file(mate)
        Rails.root.join("mate3_5_7_9_11/mate#{mate}.txt")
      end

      private def default_max
        case
        when Rails.env.production?
          nil
        when Rails.env.staging?
          500
        else
          100
        end
      end

      # rails r 'p TsMaster::Question.sample(mate: 3, max: 10).collect(&:position)'
      def sample(params = {})
        params = {
          :mate      => 3,  # N手詰
          :max       => 1,  # N件欲しい
          :retry_max => 10, # 問題が重複した分を埋める回数
        }.merge(params)

        # N手詰のpositionの範囲を取得
        scope = all.mate_eq(params[:mate])
        unless scope.exists?
          raise "#{params[:mate]}手詰問題集は空です"
        end

        pos_range = scope.minimum(:position) .. scope.maximum(:position)

        rest = params[:max]     # 残り rest 個必要
        a = []
        params[:retry_max].times do
          a.concat(rest.times.collect { rand(pos_range) })
          a = a.uniq
          rest = params[:max] - a.count # rest個足りない
          if rest.zero?                 # 0個足りないなら完成
            break
          end
          # rest個足りないので2周目へ
        end

        if a.count < params[:max]
          raise "#{params[:mate]}手詰問題を#{params[:max]}件取得したかったが#{rest}件足りない\n#{a}"
        end

        scope.where(position: a).order([Arel.sql("FIELD(position, ?)"), a])
      end
    end

    scope :mate_eq, -> mate { where(:mate => mate) }

    acts_as_list top_of_list: 0, scope: [:mate]
  end
end
