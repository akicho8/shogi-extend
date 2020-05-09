module Actf
  def self.table_name_prefix
    name.underscore.gsub("/", "_") + "_"
  end

  def self.setup(options = {})
    Colosseum::User.find_each do |e|
      e.actf_profile || e.create_actf_profile!
    end

    # if Actf::Room.count.zero?
    #   3.times do |i|
    #     tp Actf::Room.create!
    #   end
    # end
  end
end
