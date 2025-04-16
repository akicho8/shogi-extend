require "rails_helper"

RSpec.describe QuickScript::Account::EmailEditScript, type: :model do
  it "works" do
    user = User.create!
    new_email = "#{SecureRandom.hex}@localhost"
    json = QuickScript::Account::EmailEditScript.new({ email: new_email }, { current_user: user, _method: :post }).as_json
    assert { user.unconfirmed_email == new_email }
    assert { json.dig(:body, :_autolink) }
  end
end
# >> Run options: exclude {:login_spec=>true, :slow_spec=>true}
# >>
# >> QuickScript::Account::QuickScript::Account::EmailEditScript
# >>   works
# >>
# >> Top 1 slowest examples (0.25009 seconds, 10.8% of total time):
# >>   QuickScript::Account::QuickScript::Account::EmailEditScript works
# >>     0.25009 seconds -:6
# >>
# >> Finished in 2.32 seconds (files took 2.03 seconds to load)
# >> 1 example, 0 failures
# >>
