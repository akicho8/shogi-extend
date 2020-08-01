module BackendScript
  class QuestionDestroyScript < ::BackendScript::Base
    include AtomicScript::PostRedirectMod
    include TargeQuestionsMethods

    self.category = "actb"
    self.script_name = "問題削除"

    def script_body
      Actb.count_diff do
        current_target_questions.each do |question|
          question.destroy!
        end
      end
    end
  end
end
