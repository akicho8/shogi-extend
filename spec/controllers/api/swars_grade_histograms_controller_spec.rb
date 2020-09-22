require "rails_helper"

RSpec.describe Api::SwarsGradeHistogramsController, type: :controller do
  it "works" do
    get :show
    expect(response).to have_http_status(:ok)
    value = JSON.parse(response.body, symbolize_names: true)
    value                       # => {:custom_chart_params=>{:data=>{:labels=>[], :datasets=>[{:label=>nil, :data=>[]}]}, :scales_yAxes_ticks=>{}}, :records=>[], :sample_count=>0}
    assert { value[:custom_chart_params] }
    expect(response).to have_http_status(:ok)
  end
end
# >> Run options: exclude {:slow_spec=>true}
# >> .
# >> 
# >> Finished in 0.19392 seconds (files took 2.21 seconds to load)
# >> 1 example, 0 failures
# >> 
