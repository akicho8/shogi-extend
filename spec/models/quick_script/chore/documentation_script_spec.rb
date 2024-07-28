require "rails_helper"

module QuickScript
  RSpec.describe Chore::DocumentationScript, type: :model do
    it "works" do
      assert { Chore::DocumentationScript.new(page_layout: :pl_content_with_padding).call }
      assert { Chore::DocumentationScript.new(page_layout: :pl_stripped_content).call     }
      assert { Chore::DocumentationScript.new(page_layout: :pl_default).call              }
    end
  end
end
