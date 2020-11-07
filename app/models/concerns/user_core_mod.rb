module UserCoreMod
  extend ActiveSupport::Concern

  class_methods do
    def setup(options = {})
      super

      sysop
      bot
    end
  end

  included do
    scope :random_order, -> { order(Arel.sql("rand()")) }

    before_validation on: :create do
      if Rails.env.production? || Rails.env.staging?
        self.password ||= Devise.friendly_token(32)
      else
        self.password ||= "password"
      end
    end

    before_validation do
      if Rails.env.test?
        self.name ||= "test-user#{self.class.count.next}"
      end
      self.key          ||= SecureRandom.hex
      self.name         ||= name.to_s.strip
      self.email        ||= email.to_s.strip
      self.user_agent   ||= ""
      self.confirmed_at ||= Time.current
    end

    with_options presence: true do
      validates :key
    end

    with_options allow_blank: true do
      validates :email, uniqueness: true
    end

    after_create_commit do
      if Rails.env.production? || Rails.env.staging?
        SlackAgent.message_send(key: "ユーザー登録", body: attributes.slice("id", "name", "email"))
      end
    end
  end
end
