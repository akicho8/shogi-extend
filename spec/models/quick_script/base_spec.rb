require "rails_helper"

RSpec.describe QuickScript::Base, type: :model do
  it "works" do
    assert { QuickScript::Dev::FooBarBazScript.qs_key           == "dev/foo_bar_baz"                                    }
    assert { QuickScript::Dev::FooBarBazScript.qs_path          == "/lab/dev/foo-bar-baz"                               }
    assert { QuickScript::Dev::FooBarBazScript.qs_url           == "http://localhost:4000/lab/dev/foo-bar-baz"          }
    assert { QuickScript::Dev::FooBarBazScript.qs_api_url       == "http://localhost:3000/api/lab/dev/foo_bar_baz.json" }
    assert { QuickScript::Dev::FooBarBazScript.qs_api_url(:zip) == "http://localhost:3000/api/lab/dev/foo_bar_baz.zip"  }
    assert { QuickScript::Dev::FooBarBazScript.qs_group_key     == "dev"                                                }
    assert { QuickScript::Dev::FooBarBazScript.qs_page_key      == "foo_bar_baz"                                        }
  end

  it "QuickScriptDoubleCall" do
    inspect = QuickScript::Dev::NullScript.new
    assert { inspect.as_json }
    proc { inspect.as_json }.should raise_error(QuickScript::QuickScriptDoubleCall)
  end
end
