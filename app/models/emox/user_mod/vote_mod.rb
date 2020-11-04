module Emox
  module UserMod
    concern :VoteMod do
      included do
        with_options dependent: :destroy do
          has_many :emox_good_marks, class_name: "Emox::GoodMark"
          has_many :emox_bad_marks,  class_name: "Emox::BadMark"
        end
      end

      def good_bad_clip_flags_for(question)
        [:good_p, :bad_p, :clip_p].inject({}) do |a, e|
          a.merge(e => public_send(e, question))
        end
      end

      def good_p(question)
        emox_good_marks.where(question: question).exists?
      end

      def bad_p(question)
        emox_bad_marks.where(question: question).exists?
      end

      def vote_handle(params)
        question = Question.find(params[:question_id])
        vote_info = VoteInfo.fetch(params[:vote_key])

        if params[:enabled].nil?
          enabled = !vote_scope(question, vote_info).exists? # 自動トグル
        else
          enabled = params[:enabled]
        end

        ActiveRecord::Base.transaction do
          {
            question_id: question.id,
          }.tap do |e|
            e.update(vote_set(question, vote_info, enabled))
            e.update(vote_set(question, vote_info.flip, false))
            question.good_rate_update
          end
        end
      end

      private

      def vote_set(question, vote, enabled)
        s = vote_scope(question, vote)
        if enabled
          if s.exists?
            diff = 0
          else
            s.create!
            diff = 1
          end
        else
          if s.exists?
            s.destroy_all
            diff = -1
          else
            diff = 0
          end
        end
        {
          vote.key => {
            enabled: enabled, # ボタンの新しい状態
            diff: diff,       # 前回との評価数の差分
            count: question.reload.public_send("#{vote.key}_marks_count"), # トータル評価数(ビュー側では未使用)
          },
        }
      end

      def vote_scope(question, vote)
        send("emox_#{vote.key}_marks").where(question: question)
      end

      # 未使用
      def vote_toggle(question, vote)
        s = vote_scope(question, vote)
        if s.exists?
          s.destroy_all
          enable = false
          diff = -1
        else
          s.create!
          enable = true
          diff = +1
        end
        { "#{vote.key}_p": enable, "#{vote.key}_diff": diff }
      end
    end
  end
end
