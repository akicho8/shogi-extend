require "rails_helper"

RSpec.describe MediaBuilder, type: :model do
  describe "to_browser_path" do
    it "works" do
      obj = MediaBuilder.new(FreeBattle.create!)
      assert { obj.to_browser_path.match?(/system.*x-files.*png/) }
    end
  end

  describe "xxx_formatter_options" do
    def case1(params)
      obj = MediaBuilder.new(FreeBattle.create!, params)
      obj.build_options
    end
    it "works" do
      assert { case1({})                 == { width: 1200, height:  630 } }
      assert { case1("width" => "")      == { width: 1200, height:  630 } }
      assert { case1("width" => "800")   == { width:  800, height:  630 } }
      assert { case1("height" => "9999") == { width: 1200, height: 4096 } }
      assert { case1("other" => "12.34") == { width: 1200, height:  630 } }
      assert { case1("other" => true)    == { width: 1200, height:  630 } }
    end
  end

  describe "turn" do
    def case1(params)
      obj = MediaBuilder.new(FreeBattle.create!, params)
      obj.turn
    end
    it "works" do
      assert { case1("turn" =>  0)   == 0 }
      assert { case1("turn" => "0")  == 0 }
      assert { case1("turn" => "1")  == 1 }
      assert { case1("turn" => -1)   == 5 }
      assert { case1("turn" => -2)   == 4 }
      assert { case1("turn" => "-1") == 5 }
      assert { case1("turn" => "99") == 5 }
    end
  end

  describe "cache_delete" do
    it "works" do
      obj = MediaBuilder.new(FreeBattle.create!)
      path = obj.to_real_path
      assert { path.exist? }
      obj.cache_delete
      assert { !path.exist? }
    end
  end
end
# >> Run options: exclude {:slow_spec=>true}
# >> ....
# >>
# >> Finished in 2.63 seconds (files took 2.54 seconds to load)
# >> 4 examples, 0 failures
# >>
