module GoogleApi
  class ExpirationTracker < ApplicationRecord
    scope :old_only, -> expires_in { where(arel_table[:created_at].lteq(expires_in.seconds.ago)) }

    with_options presence: true do
      validates :spreadsheet_id
    end

    def spreadsheet_delete
      GoogleApi::Toolkit.new.dispatch(:spreadsheet_delete, spreadsheet_id)
    end

    # def destroy_for_general_cleaner
    #   spreadsheet_delete and destroy!
    # end

    after_destroy :spreadsheet_delete
  end
end
