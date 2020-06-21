module Acns1
  def self.table_name_prefix
    name.underscore.gsub("/", "_") + "_"
  end

  def self.setup(options = {})
    if Acns1::Room.count.zero?
      3.times do |i|
        Acns1::Room.create!
      end
      if Rails.env.development?
        tp Acns1::Room
      end
    end
  end
end
