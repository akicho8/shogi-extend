module Acns2
  class Question < ApplicationRecord
    belongs_to :user, class_name: "Colosseum::User" # 作者

    with_options dependent: :destroy do
      has_many :moves_answers  # 手順一致を正解とする答え集
      has_many :endpos_answers # 最後の局面を正解とする答え集
    end

    # with_options allow_destroy: true do
    #   accepts_nested_attributes_for :moves_answers
    #   accepts_nested_attributes_for :endpos_answers
    # end

    before_validation do
      [
        :title,
        :description,
        :hint_description,
        :source_desc,
        :other_twitter_account,
      ].each do |key|
        public_send("#{key}=", public_send(key).presence)
      end

      # self.title ||= "#{self.class.count.next}番目の問題"

      # self.difficulty_level ||= 0

      self.o_count ||= 0
      self.x_count ||= 0
    end

    with_options presence: true do
      validates :init_sfen
      # validates :difficulty_level
    end

    # with_options allow_blank: true do
    #   validates :init_sfen # , uniqueness: { case_sensitive: true }
    #   # validates :difficulty_level, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
    # end

    # jsから来たパラメーターでまとめて更新する
    def together_with_params_came_from_js_update(params)
      params = params.deep_symbolize_keys

      # params = {
      #   "question" => {
      #     "init_sfen" => "4k4/9/4GG3/9/9/9/9/9/9 b 2r2b2g4s4n4l18p #{rand(1000000)}",
      #     "moves_answers"=>[{"moves_str"=>"4c5b"}],
      #     "time_limit_clock"=>"1999-12-31T15:03:00.000Z",
      #   },
      # }.deep_symbolize_keys

      question = params[:question]

      # record = h.current_user.acns2_questions.find_or_initialize_by(id: question[:id])

      ActiveRecord::Base.transaction do
        assign_attributes(question.slice(*[
              :init_sfen,
              :title,
              :description,
              :hint_description,
              :source_desc,
              :other_twitter_account,
              :difficulty_level,
              :time_limit_sec,
            ]))

        # if Rails.env.development?
        #   if new_record?
        #     parts = init_sfen.split
        #     parts.pop
        #     parts.push(self.class.count.next)
        #     self.init_sfen = parts.join(" ")
        #     p ["#{__FILE__}:#{__LINE__}", __method__, init_sfen]
        #   end
        # end

        # a = Time.zone.parse(question[:time_limit_clock])
        # b = Time.zone.parse("2000-01-01")
        # self.time_limit_sec = a - b

        save!

        # 削除
        self.moves_answer_ids = question[:moves_answers].collect { |e| e[:id] }

        # 追加 or 更新
        question[:moves_answers].each do |e|
          moves_answer = moves_answers.find_or_initialize_by(id: e[:id])
          moves_answer.moves_str = e[:moves_str]
          moves_answer.save!
        end
      end

      # question = h.current_user.acns2_questions.create! do |e|
      #   e.assign_attributes(params[:question])
      #   # e.init_sfen = "4k4/9/4G4/9/9/9/9/9/9 b G2r2b2g4s4n4l18p 1"
      #   e.moves_answers.build(moves_str: "G*5b")
      #   e.endpos_answers.build(sfen_endpos: "4k4/4G4/4G4/9/9/9/9/9/9 w 2r2b2g4s4n4l18p 2")
      # end
    end

    # jsに渡すパラメータを作る
    def create_the_parameters_to_be_passed_to_the_js
      hash = attributes
      hash = hash.merge(moves_answers: moves_answers)
      hash
    end
  end
end
