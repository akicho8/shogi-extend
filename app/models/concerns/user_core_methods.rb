module UserCoreMethods
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

      self.key ||= SecureRandom.hex
      self.user_agent ||= ""
      self.name ||= name.to_s.strip

      if Rails.env.development?
        self.name = name.gsub(/foo/, "bar")
      end

      if name.present?
        self.name_input_at ||= Time.current
      end

      if email.blank?
        self.email = "#{key}@localhost"
        self.confirmed_at ||= Time.current
      end
    end

    with_options allow_blank: true do
      validates :name, length: 1..64
    end

    after_create_commit do
      if Rails.env.production? || Rails.env.staging?
        SlackAgent.notify(subject: "ユーザー登録", body: attributes.slice("id", "name", "email"))
      end
    end
  end
end
