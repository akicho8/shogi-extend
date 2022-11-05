module SwarsSystemSupport
  extend ActiveSupport::Concern

  included do
    before(:context) do
      command = <<~EOT
        Swars::Battle.destroy_all
        Swars.setup
        Swars::Importer::AllRuleImporter.new(user_key: "DevUser1").run
      EOT
      %x(rails runner -e development '#{command}')
    end
  end
end
