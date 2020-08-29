require "rails_helper"

RSpec.describe Api::TalksController, type: :controller do
  describe "show" do
    it "works" do
      get :show, params: { source_text: "(source_text)", full_url: false }
      value = JSON.parse(response.body, symbolize_names: true)
      value # => {:mp3_path=>"http://localhost:3000/system/talk/3c/88/3c88a9017fb38f0572360f7b03c507c8.mp3"}
      assert { value[:mp3_path].include?(".mp3") }
      assert { value[:mp3_path].start_with?("/system") }

      get :show, params: { source_text: "(source_text)", full_url: true }
      value = JSON.parse(response.body, symbolize_names: true)
      value # => 
      assert { value[:mp3_path].start_with("http") }
    end
  end
end
# >> Run options: exclude {:slow_spec=>true}
# >> F
# >> 
# >> Failures:
# >> 
# >>   1) Api::TalksController show works
# >>      Failure/Error: Unable to find - to read failed line
# >>      # -:10:in `block (3 levels) in <main>'
# >>      # ./spec/support/database_cleaner.rb:18:in `block (3 levels) in <main>'
# >>      # ./spec/support/database_cleaner.rb:18:in `block (2 levels) in <main>'
# >> 
# >> Finished in 0.19484 seconds (files took 2.34 seconds to load)
# >> 1 example, 1 failure
# >> 
# >> Failed examples:
# >> 
# >> rspec -:5 # Api::TalksController show works
# >> 
