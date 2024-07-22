# cap production deploy:upload FILES=app/models/model_structure_fix1.rb
# RAILS_ENV=production nohup bundle exec bin/rails r 'ModelStructureFix1.new.call' &
class ModelStructureFix1
  def call
    ActiveRecord::Base.logger = nil
    AppLog.important("#{self.class.name} start")
    scope = Swars::Battle.joins(:memberships).merge(Swars::Membership.where(opponent: nil)).distinct
    count = scope.count
    updated = 0
    scope.find_in_batches(batch_size: 1000) do |g|
      g.each do |battle|
        Retryable.retryable(on: ActiveRecord::Deadlocked) do
          battle.memberships[0].update_columns(:opponent_id => battle.memberships[1].id)
          battle.memberships[1].update_columns(:opponent_id => battle.memberships[0].id)
        end
        # battle.reload
        # if battle.memberships.all?(&:opponent_id)
        updated += 1
        # end
      end
      count -= g.size
      p [Time.current.to_fs(:ymdhms), count, updated]
    end
    AppLog.important("#{self.class.name} done")
  end
end
