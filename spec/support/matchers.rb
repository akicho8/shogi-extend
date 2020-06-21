# expect(JSON.parse(response.body)).to eq({success: true})
# ↓
# expect(response).to be_json_success
#
RSpec::Matchers.define :be_json_success do |expected|
  match do |actual|
    json_response = JSON.parse(actual.body)
    expect(json_response['success']).to eq(true)
  end
end
