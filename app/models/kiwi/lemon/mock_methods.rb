module Kiwi
  class Lemon
    concern :MockMethods do
      class_methods do
        def setup(options = {})
          if Rails.env.development?
            mock_setup
          end
        end

        # rails r 'Kiwi::Lemon.mock_setup'
        def mock_setup
        end

        def mock_lemon
          raise if Rails.env.production? || Rails.env.staging?

          user1 = User.find_or_create_by!(name: "user1", email: "user1@localhost")
          lemon = user1.kiwi_lemons.create_mock1
          lemon
        end
      end
    end
  end
end
