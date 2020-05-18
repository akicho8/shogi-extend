module Actf
  module Seed
    extend self
    def run(options = {})
      Season.setup(options)
      AnsResult.setup(options)

      Colosseum::User.find_each do |e|
        e.actf_profile || e.create_actf_profile!
      end
    end
  end
end
