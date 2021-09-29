module BackendScript
  class Base < ::AtomicScript::Base
    class_attribute :category
    self.category = "その他"

    self.url_prefix = [:admin, :script]

    delegate :current_user, to: :c

    # 土日祝日色
    def holiday_sunday_saturday_class(t)
      case
      when t.sunday?, HolidayJp.holiday?(t.to_date)
        "has-text-danger"
      when t.saturday?
        "has-text-info"
      end
    end

    def user_link_to(name, user)
      h.link_to(name, UserSearchScript.script_link_path(target_user_ids: user.id))
    end

    def question_link_to(name, question)
      h.link_to(name, QuestionSearchScript.script_link_path(target_question_ids: question.id))
    end

    def book_image_tag(book)
      h.image_tag(book.avatar_path, style: "height: 1rem; vertical-align: text-bottom; margin-right: 0.5rem")
    end

    def book_link_to(book)
      h.link_to(book_image_tag(book) + "#{book.title}(#{book.articles.count})".html_safe, UrlProxy.full_url_for("/rack/books/#{book.key}?force=true"))
    end

    def article_link_to(article)
      h.link_to(article.title, UrlProxy.full_url_for("/rack/articles/#{article.key}?force=true"))
    end
  end
end
