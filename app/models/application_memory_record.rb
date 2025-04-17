module ApplicationMemoryRecord
  extend ActiveSupport::Concern

  included do
    if self < MemoryRecord
    else
      include MemoryRecord
    end
  end

  class_methods do
    def lookup_key_or_first(key, default = nil, &block)
      lookup_key(key, default, &block) || first&.key
    end

    # def keys_from(values)
    #   Array(values).collect { |e| fetch(e).key }
    # end

    def fetch_from_array(values)
      Array(values).collect { |e| fetch(e) }
    end

    def lookup_from_array(values)
      Array(values).collect { |e| lookup(e) }.compact
    end

    def form_part_elems(...)
      available_form_elems.inject({}) do |a, e|
        a.merge(e.key => e.to_form_elem(...))
      end
    end

    private

    def available_form_elems
      find_all { |e| e.form_available_envs.include?(Rails.env.to_sym) }
    end
  end

  def db_record!
    db_class.find_by!(key: key)
  end

  def db_record
    db_class.find_by(key: key)
  end

  def db_class
    @db_class ||= self.class.name.remove(/Info\z/).constantize
  end

  def to_form_elem(context = nil)
    {
      :el_label   => el_value_for(:el_label, context) || name,
      :el_message => el_value_for(:el_message, context),
    }
  end

  def el_value_for(method_name, context = nil)
    if respond_to?(method_name)
      v = send(method_name)
      if v.kind_of? Proc
        v = v.call(context)
      end
      v
    end
  end

  # form_available_envs: [:production, :staging, :development, :test]
  # と書けばその環境だけで form_part_elems を有効にする
  def form_available_envs
    @form_available_envs ||= yield_self do
      if defined? super
        av = super
      else
        av = [:production, :staging, :development, :test]
      end
      av.to_set
    end
  end
end
