class User
  module FreeBattleMethods
    extend ActiveSupport::Concern

    included do
      has_many :free_battles, dependent: :destroy
    end
  end
end
