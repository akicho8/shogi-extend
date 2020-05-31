module Actb
  concern :StaticArModel do
    included do
      cattr_accessor(:pure_class) { "#{name}Info".constantize }

      acts_as_list top_of_list: 0
      default_scope { order(:position) }

      with_options presence: true do
        validates :key
      end

      validates :key, allow_blank: true, inclusion: pure_class.keys.collect(&:to_s)

      unless method_defined?(:name)
        delegate :name, to: :pure_info
      end
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

    def pure_info
      pure_class.fetch(key)
    end
  end
end
