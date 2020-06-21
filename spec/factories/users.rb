FactoryBot.define do
  factory :user, :class => User do
    joined_at { "2000-01-01" }
  end
end
