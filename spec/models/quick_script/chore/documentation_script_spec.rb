require "rails_helper"

RSpec.describe QuickScript::Chore::DocumentationScript, type: :model do
  it "works" do
    assert { QuickScript::Chore::DocumentationScript.new(page_layout: :pl_content_with_padding).call }
    assert { QuickScript::Chore::DocumentationScript.new(page_layout: :pl_stripped_content).call     }
    assert { QuickScript::Chore::DocumentationScript.new(page_layout: :pl_default).call              }
  end
end
