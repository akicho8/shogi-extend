module Acns3
  def self.table_name_prefix
    name.underscore.gsub("/", "_") + "_"
  end

  def self.setup(options = {})
    Colosseum::User.find_each do |e|
      e.acns3_profile || e.create_acns3_profile!
    end

    # if Acns3::Room.count.zero?
    #   3.times do |i|
    #     tp Acns3::Room.create!
    #   end
    # end
  end
end
