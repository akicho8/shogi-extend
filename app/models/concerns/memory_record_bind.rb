# 静的レコードをARに反映するモジュール
#
#   class RuleInfo
#     include ApplicationMemoryRecord
#     memory_record [
#       { key: :key1,  name: "名前1", },
#     end
#   end
#
#   class Rule < ApplicationRecord
#     include MemoryRecordBind::Basic
#   end
#
#   rails r 'Rule.setup'
#   rails r 'tp Rule'
#
module MemoryRecordBind
  concern :Base do
    included do
      cattr_accessor(:pure_class) { "#{name}Info".constantize }

      with_options presence: true do
        validates :key
      end

      validates :key, allow_blank: true, inclusion: pure_class.keys.collect(&:to_s)

      if !method_defined?(:name)
        delegate :name, to: :pure_info
      end
    end

    class_methods do
      def setup(options = {})
        pure_class.each.with_index do |e, i|
          record = find_by(key: e.key) || new(key: e.key)
          record.attribute_copy_from(e, i)
          record.save!
        end
      end

      def fetch(key)
        if key.kind_of? self
          return key
        end

        # if Rails.env.test?
        #   if !find_by(key: key)
        #     setup
        #   end
        # end

        pure_class.fetch(key).db_record!

      # info = pure_class.fetch(key)
      #
      # find_by!(key: info.key)
      rescue ActiveRecord::RecordNotFound => error
        if Rails.env.local?
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

        if info = pure_class.lookup(key)
          find_by(key: info.key)
        end
      end

      def [](key)
        lookup(key)
      end

      # def keys_from(values)
      #   Array(values).collect { |e| fetch(e).key }
      # end

      def fetch_from_array(values)
        Array(values).collect { |e| fetch(e) }
      end
    end

    def pure_info
      pure_class.fetch(key)
    end

    def attribute_copy_from(info, index)
    end
  end

  concern :Basic do
    include Base

    included do
      acts_as_list top_of_list: 0, touch_on_update: false
      default_scope { order(:position) }
    end

    class_methods do
      def setup(*)
        self.acts_as_list_no_update do
          super
        end
      end
    end

    def attribute_copy_from(info, index)
      self.position = info.code
    end
  end
end
