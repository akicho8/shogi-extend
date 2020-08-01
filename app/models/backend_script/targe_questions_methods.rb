module BackendScript
  concern :TargeQuestionsMethods do
    def form_parts
      super + [
        {
          :label   => "対象問題IDs",
          :key     => :target_question_ids,
          :type    => :string,
          :default => current_target_question_ids.join(" "),
        },
      ]
    end

    private

    def current_target_question_ids
      params[:target_question_ids].to_s.scan(/\d+/).collect(&:to_i).uniq
    end

    def current_target_questions
      if v = current_target_question_ids
        Actb::Question.find(v)
      end
    end
  end
end
