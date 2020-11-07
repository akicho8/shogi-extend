class SessionUser < ApplicationRecord
  belongs_to :user

  before_validation on: :create do
    self.user ||= User.create!
    self.key ||= SecureRandom.hex
  end
end
