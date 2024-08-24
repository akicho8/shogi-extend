class Fix57 < ActiveRecord::Migration[6.0]
  def change
    AppLog.important Swars::Membership.where(judge: Judge[:lose]).tagged_with("背水の陣").count
    memberships = Swars::Membership.where(judge: Judge[:lose]).tagged_with("背水の陣")
    memberships.each do |e|
      e.note_tag_list = e.note_tag_list - ["背水の陣"]
      Retryable.retryable(on: ActiveRecord::Deadlocked) do
        e.save!
      end
    end
    AppLog.important Swars::Membership.where(judge: Judge[:lose]).tagged_with("背水の陣").count
  end
end
