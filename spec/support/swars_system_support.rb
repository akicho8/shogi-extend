module SwarsSystemSupport
  extend ActiveSupport::Concern

  included do
    before(:context) do
      # system "rails runner -e development 'tp Swars.info'"
      command = <<~EOT
        Swars::Battle.destroy_all
        Swars.setup
        Swars::Importer::AllRuleImporter.new(user_key: "DevUser1").run
      EOT
      %x(rails runner -e development '#{command}')
      # system "rails runner -e development 'tp Swars.info'"
    end
  end
end
