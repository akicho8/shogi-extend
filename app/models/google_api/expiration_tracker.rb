module GoogleApi
  class ExpirationTracker < ApplicationRecord
    scope :old_only, -> expires_in { where(arel_table[:created_at].lteq(expires_in.seconds.ago)) }

    with_options presence: true do
      validates :spreadsheet_id
    end

    after_destroy do
      AppLog.info(subject: "[GoogleApi][spreadsheet_id][削除]", body: spreadsheet_id)
      toolkit = GoogleApi::Toolkit.new
      toolkit.spreadsheet_delete(spreadsheet_id)
    end
  end
end
