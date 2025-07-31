require "rails_helper"

RSpec.describe ShareBoard::KifuMailSender, type: :model do
  it "works" do
    assert { ShareBoard::KifuMailSender.new(KifuMailAdapter.mock_params).call }
  end
end
