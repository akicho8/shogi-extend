module Acns2
  def self.table_name_prefix
    name.underscore.gsub("/", "_") + "_"
  end

  def self.setup(options = {})
    # if Acns2::Room.count.zero?
    #   3.times do |i|
    #     tp Acns2::Room.create!
    #   end
    # end
  end
end
