module Actf
  module UserMod
    concern :VoteMod do
      included do
        with_options(dependent: :destroy) do
          has_many :actf_good_marks, class_name: "Actf::GoodMark"
          has_many :actf_bad_marks, class_name: "Actf::BadMark"
        end
      end

      def vote_handle(params)
        question = Question.find(params[:question_id])
        vote_info = VoteInfo.fetch(params[:vote_key])
        retv = {}
        retv.update(vote_set(question, vote_info, params[:vote_value]))
        retv.update(vote_set(question, vote_info.flip, false))
        retv
      end

      private

      def vote_set(question, vote, enable)
        s = vote_scope(question, vote)
        if enable
          if s.exists?
            diff = 0
          else
            s.create!
            diff = 1
          end
          enable = true
        else
          if s.exists?
            s.destroy_all
            diff = -1
          else
            diff = 0
          end
          enable = false
        end
        { "#{vote.key}_p": enable, "#{vote.key}_diff": diff }
      end

      def vote_scope(question, vote)
        send("actf_#{vote.key}_marks").where(question: question)
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
          diff = 1
        end
        { "#{vote.key}_p": enable, "#{vote.key}_diff": diff }
      end
    end
  end
end
