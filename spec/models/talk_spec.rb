require 'rails_helper'

RSpec.describe Talk do
  it do
    Timecop.return do
      talk = Talk.new(source_text: "こんにちは")
      hash = talk.as_json
      assert { hash[:service_path] }
    end
  end
end
