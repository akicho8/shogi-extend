module ApplicationMemoryRecord
  extend ActiveSupport::Concern

  included do
    include MemoryRecord
  end

  def name
    key.to_s
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
