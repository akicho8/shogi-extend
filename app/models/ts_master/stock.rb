module TsMaster
  class Stock < ApplicationRecord
    class << self
      # rails r 'TsMaster::Stock.setup(mate: 3, max: 100)'
      def setup(options = {})
        options = {
          max: default_max,
          mate: [3, 5, 7, 9, 11],
          reset: false,
        }.merge(options)

        if options[:reset]
          destroy_all
        end

        Array(options[:mate]).each do |mate|
          mate_import(mate, options)
        end
      end

      private def mate_import(mate, options = {})
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
        else
          10
        end
      end

      # rails r 'p TsMaster::Stock.sample(mate: 3, max: 10).collect(&:position)'
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

        scope.where(position: a).order(["FIELD(position, ?)", a])
      end
    end

    scope :mate_eq, -> mate { where(:mate => mate) }

    acts_as_list top_of_list: 0, scope: [:mate]
  end
end
