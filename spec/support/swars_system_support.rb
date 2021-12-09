module SwarsSystemSupport
  extend ActiveSupport::Concern

  included do
    before(:context) do
      command = <<~EOT
        Swars::Battle.destroy_all
        Swars.setup
        Swars::Battle.user_import(user_key: "devuser1")
      EOT
      %x(rails runner -e development '#{command}')
    end
  end
end
