class Fix58 < ActiveRecord::Migration[6.0]
  def change
    Swars::Membership.in_batches(of: 10000) do |relation|
      p relation.count
      relation.where(judge: [Judge[:lose], Judge[:draw]]).tagged_with("背水の陣").each do |e|
        p e.id
        e.note_tag_list = e.note_tag_list - ["背水の陣"]
        Retryable.retryable(on: ActiveRecord::Deadlocked) do
          e.save!
        end
      end
    end
    QuickScript::Swars::TacticStatScript.primary_aggregate_run
  end
end
