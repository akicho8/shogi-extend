module UserProfileMethods
  extend ActiveSupport::Concern

  included do
    has_one :profile, dependent: :destroy, autosave: true
    accepts_nested_attributes_for :profile
    delegate :description, :twitter_key, to: :profile

    after_create do
      profile || create_profile
    end
  end

  def twitter_url
    if v = twitter_key.presence
      "https://twitter.com/#{v}"
    end
  end
end
