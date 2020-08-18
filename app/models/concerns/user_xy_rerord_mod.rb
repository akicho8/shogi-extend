module UserXyRerordMod
  extend ActiveSupport::Concern

  included do
    # rails r "tp User.first.xy_records"
    has_many :xy_records, dependent: :destroy
  end
end
