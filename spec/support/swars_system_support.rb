module SwarsSystemSupport
  extend ActiveSupport::Concern

  included do
    before(:context) do
      command = <<~EOT
        Swars::Battle.destroy_all
        Swars.setup
        Swars::Importer::UserImporter.new(user_key: "devuser1").run
      EOT
      %x(rails runner -e development '#{command}')
    end
  end
end
