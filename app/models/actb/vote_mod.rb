module Actb
  concern :VoteMod do
    included do
      belongs_to :user, class_name: "::User"
      belongs_to :question, counter_cache: true
    end
  end
end
