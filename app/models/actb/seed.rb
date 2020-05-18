module Actb
  module Seed
    extend self
    def run(options = {})
      AnsResult.setup(options)
      Season.setup(options)

      Colosseum::User.find_each do |e|
        e.actb_profile || e.create_actb_profile!
      end
    end
  end
end
