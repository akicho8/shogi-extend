module Actb
  concern :StaticArModel do
    included do
      acts_as_list top_of_list: 0
      default_scope { order(:position) }

      cattr_accessor(:pure_class) { "#{name}Info".classify }
    end

    class_methods do
      def setup(options = {})
        pure_class.each do |e|
          find_or_create_by!(key: e.key)
        end
      end

      def fetch(key)
        find_by!(key: key)
      end

      def lookup(key)
        find_by(key: key)
      end

      def [](key)
        lookup(key: key)
      end
    end

    with_options presence: true do
      validates :key
    end

    with_options allow_blank: true do
      validates :key, inclusion: pure_class.keys.collect(&:to_s)
    end

    def static_info
      pure_class.fetch(key)
    end
  end
end
