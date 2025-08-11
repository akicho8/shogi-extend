require "rails_helper"

RSpec.describe AdapterReceiver, type: :model do
  it "works" do
    assert { AdapterReceiver.call(input_text: nil) }
    assert { AdapterReceiver.call(input_text: "68銀") }
    assert { AdapterReceiver.call(input_text: "") rescue $!.class == Bioshogi::FileFormatError }
    assert { AdapterReceiver.call(input_text: "58金") rescue $!.class == Bioshogi::AmbiguousFormatError }
  end
end
