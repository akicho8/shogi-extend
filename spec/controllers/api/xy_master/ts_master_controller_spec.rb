require 'rails_helper'

RSpec.describe Api::TsMaster::TimeRecordsController, type: :controller do
  it "questions_fetch" do
    ::TsMaster::Question.setup
    get :index, params: { questions_fetch: true, rule_key: :rule100t, format: :json }
    expect(response).to have_http_status(:ok)
    body = JSON.parse(response.body)   # => {"questions"=>[{"id"=>128, "sfen"=>"lnsg4l/1r1b5/p1pp1+N1+R1/4p3p/9/P3SSk2/NpPPPPg1P/2GK5/L1S4NL b 2Pbg4p 91", "mate"=>3, "position"=>9, "created_at"=>"2020-12-30T08:20:23.000+09:00", "updated_at"=>"2020-12-30T08:20:23.000+09:00"}, {"id"=>127, "sfen"=>"l1+R5l/2pS5/p2pp+P1pp/2k3p2/2N4P1/PP2R1P1P/2+pPP1N2/2GSG1bs1/LN1K4L b 2GSNPbp 73", "mate"=>3, "position"=>8, "created_at"=>"2020-12-30T08:20:23.000+09:00", "updated_at"=>"2020-12-30T08:20:23.000+09:00"}]}
    assert { body["questions"] }
  end
end
# >> Run options: exclude {:slow_spec=>true}
# >> .
# >> 
# >> Finished in 0.37946 seconds (files took 2.42 seconds to load)
# >> 1 example, 0 failures
# >> 
