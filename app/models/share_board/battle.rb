module ShareBoard
  class Battle < ApplicationRecord
    belongs_to :room, touch: true, counter_cache: true
    acts_as_list top_of_list: 0, scope: :room

    belongs_to :win_location, class_name: "Location"

    has_many :memberships, -> { order(:position) }, dependent: :destroy, inverse_of: :battle

    has_many :users, through: :memberships

    scope :newest_order, -> { order(position: :desc) }

    before_validation on: :create do
      self.key ||= SecureRandom.hex
      self.win_location ||= Location.fetch(:black)
      self.sfen ||= "position sfen lnsgkgsnl/1r5b1/ppppppppp/9/9/9/PPPPPPPPP/1B5R1/LNSGKGSNL b - 1 moves 7g7f 3c3d 8h2b+ 3a2b"
      self.turn ||= Bioshogi::Parser.parse(sfen).container.turn_info.turn_offset
      self.title ||= ""
    end

    with_options presence: true do
      validates :key
      validates :sfen
      validates :turn
    end

    after_create do
      room.reload.roomships.each(&:rank_update) # Membership.create! 経由で roomship が更新されているため reload が必要
    end

    LocationInfo.each do |e|
      define_method(e.key) do
        memberships.where(location: Location.fetch(e.key))
      end
    end
  end
end
