module ShareBoard
  class User < ApplicationRecord
    class << self
      def [](name)
        find_or_initialize_by(name: name)
      end
    end

    has_many :memberships, dependent: :destroy # 対局時の情報(複数)
    has_many :battles, through: :memberships   # 対局(複数)

    before_validation do
      self.name ||= "#{self.class.name.demodulize.underscore}#{self.class.count.next}"
    end

    with_options presence: true do
      validates :name
    end

    with_options allow_blank: true do
      validates :name, uniqueness: { case_sensitive: true }
    end

    def score_by_room(room)
      room.score_by_user(self)
      # room.memberships.where(user: self, judge: Judge.fetch(:win)).count
    end
  end
end
