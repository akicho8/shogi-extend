require "#{__dir__}/test_methods"

module Swars
  module ZipDl
    RSpec.describe Summary, type: :model, swars_spec: true, zip_dl_spec: true do
      include TestMethods

      it "works" do
        main_builder = MainBuilder.new(base_params)
        is_asserted_by { main_builder.to_summary }
      end
    end
  end
end
