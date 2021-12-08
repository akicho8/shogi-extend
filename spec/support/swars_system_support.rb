module SwarsSystemSupport
  extend ActiveSupport::Concern

  included do
    before(:context) do
      command = <<~EOT
        Swars.setup
        Swars::Battle.destroy_all
        Swars::Battle.user_import(user_key: "devuser1")
      EOT
      %x(rails r '#{command}')
    end
  end
end
