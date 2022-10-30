class User
  module TagMethods
    extend ActiveSupport::Concern

    included do
      acts_as_taggable_on :permit_tags
    end
  end
end
