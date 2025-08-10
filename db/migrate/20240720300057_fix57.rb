class Fix57 < ActiveRecord::Migration[6.0]
  def change
    AppLog.important Swars::Membership.where(judge: Judge[:lose]).tagged_with("屍の舞").count
    memberships = Swars::Membership.where(judge: Judge[:lose]).tagged_with("屍の舞")
    memberships.each do |e|
      e.note_tag_list = e.note_tag_list - ["屍の舞"]
      Retryable.retryable(on: ActiveRecord::Deadlocked) do
        e.save!
      end
    end
    AppLog.important Swars::Membership.where(judge: Judge[:lose]).tagged_with("屍の舞").count
  end
end
