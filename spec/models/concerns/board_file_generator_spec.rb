require 'rails_helper'

RSpec.describe BoardFileGenerator, type: :model do
  describe "to_browser_path" do
    it "works" do
      obj = BoardFileGenerator.new(FreeBattle.create!)
      assert { obj.to_browser_path.match?(/system.*board_images.*png/) }
    end
  end

  describe "xxx_formatter_options" do
    def test1(params)
      obj = BoardFileGenerator.new(FreeBattle.create!, params)
      obj.to_method_options
    end
    it "works" do
      assert { test1({})                 == {width: 1200, height: 630} }
      assert { test1("width" => "")      == {width: 1200, height: 630} }
      assert { test1("width" => "800")   == {width:  800, height: 630} }
      assert { test1("height" => "9999") == {width: 1200, height: 1200} }
      assert { test1("other" => "12.34") == {width: 1200, height: 630} }
      assert { test1("other" => "true")  == {width: 1200, height: 630}  }
    end
  end

  describe "turn" do
    def test1(params)
      obj = BoardFileGenerator.new(FreeBattle.create!, params)
      obj.turn
    end
    it "works" do
      assert { test1("turn" =>  0)   == 0 }
      assert { test1("turn" => "0")  == 0 }
      assert { test1("turn" => "1")  == 1 }
      assert { test1("turn" => -1)   == 5 }
      assert { test1("turn" => -2)   == 4 }
      assert { test1("turn" => "-1") == 5 }
      assert { test1("turn" => "99") == 5 }
    end
  end

  describe "cache_delete" do
    it "works" do
      obj = BoardFileGenerator.new(FreeBattle.create!)
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
