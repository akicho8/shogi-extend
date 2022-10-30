class User
  module ProfileMethods
    extend ActiveSupport::Concern

    included do
      has_one :profile, dependent: :destroy, autosave: true
      accepts_nested_attributes_for :profile
      delegate :description, :twitter_key, :twitter_url, to: :profile

      after_create do
        profile || create_profile
      end
    end
  end
end
