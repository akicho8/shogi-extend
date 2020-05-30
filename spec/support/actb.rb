RSpec::Rails::ModelExampleGroup.module_eval do
  concerning :ActbMethods do
    # included do
    #   before do
    #   end
    #   after do
    #   end
    # end

    def sysop
      Colosseum::User.sysop
    end
  end
end
