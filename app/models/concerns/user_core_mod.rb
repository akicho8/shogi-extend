module UserCoreMod
  extend ActiveSupport::Concern

  class_methods do
    def setup(options = {})
      super

      sysop
      bot

      CpuBrainInfo.each do |e|
        unless find_by(key: e.key)
          create! do |o|
            o.key           = e.key
            o.race_key      = :robot
            o.cpu_brain_key = e.key
            o.name          = "CPU#{robot_only.count.next}号"
            o.email         = "shogi.extend+cpu-#{e.key}@gmail.com"
            o.confirmed_at  = Time.current
          end
        end
      end
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
      self.key ||= SecureRandom.hex
      self.user_agent ||= ""
      self.name ||= ""

      if Rails.env.test?
        self.name = name.presence || "test-user#{self.class.count.next}"
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
        SlackAgent.message_send(key: "ユーザー登録", body: attributes.slice("id", "name", "email"))
      end
    end
  end
end
