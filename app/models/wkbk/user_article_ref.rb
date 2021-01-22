module Wkbk
  concern :UserArticleRef do
    included do
      belongs_to :user, class_name: "::User"
      belongs_to :article, counter_cache: true
    end
  end
end
