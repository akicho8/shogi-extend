module StaticArModel
  extend ActiveSupport::Concern
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
        record = find_by(key: e.key) || create!(key: e.key)
        record.move_to_bottom
      end
    end

    def fetch(key)
      if key.kind_of? self
        return key
      end
      find_by!(key: key)
    rescue ActiveRecord::RecordNotFound => error
      if Rails.env.test? || Rails.env.development?
        raise ArgumentError, "#{name}.fetch(#{key.inspect})\nkeys: #{pluck(:key).inspect}"
      end
      raise error
    end

    def fetch_if(key)
      if key
        fetch(key)
      end
    end

    def lookup(key)
      if key.kind_of? self
        return key
      end
      find_by(key: key)
    end

    def [](key)
      lookup(key)
    end
  end

  def pure_info
    pure_class.fetch(key)
  end
end
