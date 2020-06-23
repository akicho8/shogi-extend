module Actb
  class BestQuestionsGenerator
    attr_accessor :params

    def initialize(params)
      @params = {
        :trace => false,
      }.merge(params)

      if block_given?
        yield self
      end
    end

    # FIXME: 二人のRの平均に合った問題を出題する
    def generate
      # s = Question.all
      # s = s.joins(:folder).where(Folder.arel_table[:type].eq("Actb::ActiveBox"))
      # s = s.order("rand()")
      # s = s.limit(Config[:best_questions_limit])
      # s = Question.where(id: s.ids).order(:difficulty_level)
      # s.collect(&:as_json_type3)

      s = Question.all
      s = s.joins(:folder).where(Folder.arel_table[:type].eq("Actb::ActiveBox"))
      s = s.order(:id)
      s = s.limit(Config[:best_questions_limit])
      s.collect(&:as_json_type3)
    end
  end
end
