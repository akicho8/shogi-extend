module EmoxSupportMethods
  extend ActiveSupport::Concern

  included do
    before(:context) do
      Emox.setup
    end

    let(:user1) { User.create!(name: "user1", email: "user1@localhost", confirmed_at: Time.current) }
    let(:user2) { User.create!(name: "user2", email: "user2@localhost", confirmed_at: Time.current) }
    let(:user3) { User.create!(name: "user3", email: "user3@localhost", confirmed_at: Time.current) }

    let(:room1) do
      Emox::Room.create_with_members!([user1, user2])
    end

    let(:battle1) do
      room1.battle_create_with_members!
    end
  end
end

RSpec::Rails::ModelExampleGroup.module_eval do
  concerning :EmoxMethods do
  end
end
