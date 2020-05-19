module Actb
  class Kind < ApplicationRecord
    class << self
      def setup(options = {})
        ::Actb::KindInfo.each do |e|
          find_or_create_by!(key: e.key)
        end
      end

      def fetch(key)
        find_by!(key: key)
      end
    end

    has_many :questions, dependent: :destroy

    with_options presence: true do
      validates :key
    end

    with_options allow_blank: true do
      validates :key, inclusion: KindInfo.keys.collect(&:to_s)
    end

    def static_info
      KindInfo.fetch(key)
    end
  end
end
