class UserReception < ApplicationRecord
  belongs_to :battle_user, counter_cache: true, touch: :last_reception_at
end
