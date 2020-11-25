# rails r 'tp Swars::ZipDlLog'

module Swars
  class ZipDlLog < ApplicationRecord
    belongs_to :user,       class_name: "::User"
    belongs_to :swars_user, class_name: "::Swars::User"

    with_options presence: true do
      validates :begin_at
      validates :end_at
    end
  end
end
