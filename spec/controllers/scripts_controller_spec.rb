require 'rails_helper'

RSpec.describe ScriptsController, type: :controller do
  describe "すべてのスクリプト" do
    FrontendScript.bundle_scripts.each do |e|
      it e.script_name do
        get :show, params: { id: e.key }
        assert { response.status == 200 }
      end
    end
  end
end
# >> Run options: exclude {:slow_spec=>true}
# >> 
# >> All examples were filtered out
# >> 
# >> 
# >> Finished in 0.7345 seconds (files took 2.43 seconds to load)
# >> 0 examples, 0 failures
# >> 
