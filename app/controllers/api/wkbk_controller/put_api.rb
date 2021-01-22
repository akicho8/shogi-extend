module Api
  class WkbkController
    concern :PutApi do
      def article_save_handle
        if id = params[:article][:id]
          article = Wkbk::Article.find(id)
        else
          article = current_user.wkbk_articles.build
        end
        begin
          article.update_from_js(params.to_unsafe_h[:article])
        rescue ActiveRecord::RecordInvalid => error
          return { form_error_message: error.message }
        end
        { article: article.as_json(Wkbk::Article.json_type5) }
      end
    end
  end
end
