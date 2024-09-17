require "rails_helper"

module QuickScript
  RSpec.describe Base, type: :model do
    it "works" do
      assert { Dev::FooBarBazScript.qs_key           == "dev/foo_bar_baz"                                    }
      assert { Dev::FooBarBazScript.qs_path          == "/lab/dev/foo-bar-baz"                               }
      assert { Dev::FooBarBazScript.qs_url           == "http://localhost:4000/lab/dev/foo-bar-baz"          }
      assert { Dev::FooBarBazScript.qs_api_url       == "http://localhost:3000/api/lab/dev/foo_bar_baz.json" }
      assert { Dev::FooBarBazScript.qs_api_url(:zip) == "http://localhost:3000/api/lab/dev/foo_bar_baz.zip"  }
      assert { Dev::FooBarBazScript.qs_group_key     == "dev"                                                }
      assert { Dev::FooBarBazScript.qs_page_key      == "foo_bar_baz"                                        }
    end

    it "QuickScriptDoubleCall" do
      inspect = Dev::NullScript.new
      assert { inspect.as_json }
      proc { inspect.as_json }.should raise_error(QuickScriptDoubleCall)
    end
  end
end
