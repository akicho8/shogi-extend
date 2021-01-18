module Api
  class WbookController
    concern :PutApi do
      def question_save_handle
        if id = params[:question][:id]
          question = Wbook::Question.find(id)
        else
          question = current_user.wbook_questions.build
        end
        begin
          question.update_from_js(params.to_unsafe_h[:question])
        rescue ActiveRecord::RecordInvalid => error
          return { form_error_message: error.message }
        end
        { question: question.as_json(Wbook::Question.json_type5) }
      end
    end
  end
end
