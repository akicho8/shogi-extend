require "rails_helper"

module QuickScript
  RSpec.describe Base, type: :model do
    it "works" do
      assert { Dev::FooBarBazScript.qs_key       == "dev/foo_bar_baz"                                    }
      assert { Dev::FooBarBazScript.qs_link_path == "/bin/dev/foo-bar-baz"                               }
      assert { Dev::FooBarBazScript.qs_api_url   == "http://localhost:3000/api/bin/dev/foo_bar_baz.json" }
      assert { Dev::FooBarBazScript.qs_group_key == "dev"                                                }
      assert { Dev::FooBarBazScript.qs_page_key  == "foo_bar_baz"                                        }
    end
  end
end
