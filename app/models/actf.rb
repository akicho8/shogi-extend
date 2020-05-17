module Actf
  extend self

  def table_name_prefix
    name.underscore.gsub("/", "_") + "_"
  end

  def setup(options = {})
    Colosseum::User.find_each do |e|
      e.actf_profile || e.create_actf_profile!
    end

    AnsResult.setup(options)

    Season.setup(options)

    if Rails.env.development?
    end
  end

  def destroy_all
    Actf::Question.destroy_all
    Actf::Room.destroy_all
  end
end
