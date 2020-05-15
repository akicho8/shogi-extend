module Actf
  concern :GoodBadMod do
    included do
      belongs_to :user, class_name: "Colosseum::User" # , foreign_key: "colosseum_user_id"
      belongs_to :question, counter_cache: true
    end
  end
end
