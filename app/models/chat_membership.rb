class ChatMembership < ApplicationRecord
  belongs_to :chat_room
  belongs_to :chat_user

  scope :black, -> { where(location_key: "black") }
  scope :white, -> { where(location_key: "white") }

  scope :active, -> { where.not(location_key: nil) }

  acts_as_list top_of_list: 0, scope: :chat_room

  before_validation on: :create do
    active = chat_room.chat_memberships.active
    if active.count < Warabi::Location.count
      if chat_membership = active.first
        location = chat_membership.location
      else
        location = Warabi::Location[ChatRoom.count.modulo(Warabi::Location.count)]
      end
      self.location_key ||= location.flip.key
    end
  end

  # before_validation do
  #   if location_key == "watching"
  #     self.location_key = nil
  #   end
  # end

  with_options presence: true do
    # validates :location_key
  end

  with_options allow_blank: true do
    validates :location_key, inclusion: Warabi::Location.keys.collect(&:to_s)
  end

  def location
    Warabi::Location[location_key]
  end

  def location_flip!
    if location
      update!(location_key: location.flip.key)
    end
  end
end
