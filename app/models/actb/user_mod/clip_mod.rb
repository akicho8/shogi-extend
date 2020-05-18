module Actb::UserMod
  concern :ClipMod do
    included do
      has_many :actb_clip_marks, class_name: "Actb::ClipMark", dependent: :destroy
    end

    def clip_p(question)
      actb_clip_marks.where(question: question).exists?
    end

    # from app/javascript/actb_app/the_history.vue
    # clip_handle(question_id: question.id, clip_p: clip_p)
    def clip_handle(params)
      question = Actb::Question.find(params[:question_id])
      clip_set(question, params[:clip_p])
    end

    private

    def clip_set(question, enable)
      s = actb_clip_marks.where(question: question)
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
      { clip_p: enable, diff: diff }
    end
  end
end
