require "rails_helper"

module QuickScript
  module Swars
    RSpec.describe PrisonNewScript, type: :model do
      xit "works" do
        response = PrisonNewScript.new(_method: "post", swars_user_key: "foo").as_json
        # redis が参照できないので動かない
      end
    end
  end
end
