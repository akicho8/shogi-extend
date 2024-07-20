# RAILS_ENV=production nohup bundle exec bin/rails r 'Swars::ModelStructureFix1' &
class ModelStructureFix1
  def call
    AppLog.important("#{self.class.name} start")
    scope = Swars::Battle.joins(:memberships).merge(Swars::Membership.where(opponent: nil)).distinct
    count = scope.count
    scope.find_in_batches(batch_size: 1000) do |g|
      updated = 0
      g.each do |battle|
        battle.memberships[0].opponent = battle.memberships[1]
        battle.memberships[1].opponent = battle.memberships[0]
        battle.memberships.each do |e|
          Retryable.retryable(on: ActiveRecord::Deadlocked) do
            e.save!(validate: false)
          end
        end
        battle.reload
        if battle.memberships.all?(&:opponent_id)
          updated += 1
        end
      end
      count -= g.size
      p [Time.current.to_fs(:ymdhms), count, updated]
    end
    AppLog.important("#{self.class.name} done")
  end
end
