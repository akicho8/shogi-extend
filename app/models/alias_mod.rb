module AliasMod
  extend ActiveSupport::Concern

  class_methods do
    def lookup(v)
      super || invert_table[key_cast(v)]
    end

    private

    def invert_table
      # class に secondary_key (シンボル) を定義する場合
      #
      # @invert_table ||= inject({}.with_indifferent_access) do |a, e|
      #   key = respond_to?(:secondary_key) ? secondary_key : nil
      #   Array(key).flatten.compact.inject(a) do |a, key|
      #     if value = e.send(key)
      #       a = a.merge(value => e)
      #     end
      #     a
      #   end
      # end

      # instance に値を定義する場合
      @invert_table ||= inject({}.with_indifferent_access) do |a, object|
        keys = object.try(:secondary_key)
        Array(keys).flatten.compact.inject(a) do |a, key|
          a.merge(key => object)
        end
      end
    end
  end
end
