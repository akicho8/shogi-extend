module TsMaster
  class QuestionSample
    attr_accessor :model
    attr_accessor :params

    def initialize(model, params = {})
      @model = model
      @params = {
        :mate      => 3,  # N手詰
        :max       => 1,  # N件欲しい
        :retry_max => 10, # 問題が重複した分を埋める回数
      }.merge(params)
    end

    def sample
      unless scope.exists?
        raise "#{params[:mate]}手詰問題集は空です"
      end

      a = random_positions

      n = params[:max] - a.count
      if n >= 1
        raise "#{params[:mate]}手詰問題を#{params[:max]}件取得したかったが#{n}件足りない\n#{a}"
      end

      records = scope.where(position: a).order([Arel.sql("FIELD(position, ?)"), a])

      if records.count != a.count
        raise "#{params[:mate]}手詰用positionに抜けがある\n#{a}"
      end

      records
    end

    private

    def scope
      model.mate_eq(params[:mate])
    end

    def position_range
      @position_range ||= scope.minimum(:position) .. scope.maximum(:position)
    end

    def random_positions
      n = params[:max]
      a = []
      params[:retry_max].times do
        new_positions = n.times.collect { rand(position_range) }
        a = a.concat(new_positions).uniq
        n = params[:max] - a.count
        if n.zero?
          break
        end
      end
      a
    end
  end
end
