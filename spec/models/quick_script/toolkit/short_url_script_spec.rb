require "rails_helper"

module QuickScript
  module Toolkit
    RSpec.describe ShortUrlScript, type: :model do
      it "works" do
        assert { ShortUrlScript.new(_method: :post, original_url: "http://localhost:3000/").call == { _autolink: "http://localhost:3000/u/zZSGrCkrLPo" } }
      end
    end
  end
end
