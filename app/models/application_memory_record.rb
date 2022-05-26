module ApplicationMemoryRecord
  extend ActiveSupport::Concern

  included do
    if self < MemoryRecord
    else
      include MemoryRecord
    end
  end

  class_methods do
    def keys_from(values)
      Array(values).collect { |e| fetch(e).key }
    end

    def array_from(values)
      Array(values).collect { |e| fetch(e) }
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
end
