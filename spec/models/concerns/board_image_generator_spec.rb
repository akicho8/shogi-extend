require 'rails_helper'

RSpec.describe BoardImageGenerator, type: :model do
  describe "to_browser_path" do
    it "works" do
      obj = BoardImageGenerator.new(FreeBattle.create!)
      assert { obj.to_browser_path.match?(/system.*board_images.*png/) }
    end
  end

  describe "to_blob_options" do
    def test1(params)
      obj = BoardImageGenerator.new(FreeBattle.create!, params)
      obj.to_blob_options
    end
    it "works" do
      assert { test1({})                 == {width: 1200, height: 630} }
      assert { test1("width" => "")      == {width: 1200, height: 630} }
      assert { test1("width" => "800")   == {width:  800, height: 630} }
      assert { test1("height" => "9999") == {width: 1200, height: 630} }
      assert { test1("other" => "12.34") == {width: 1200, height: 630, other: 12.34} }
      assert { test1("other" => "true")  == {width: 1200, height: 630, other: true}  }
    end
  end

  describe "cache_delete" do
    it "works" do
      obj = BoardImageGenerator.new(FreeBattle.create!)
      path = obj.to_real_path
      assert { path.exist? }
      obj.cache_delete
      assert { !path.exist? }
    end
  end
end
