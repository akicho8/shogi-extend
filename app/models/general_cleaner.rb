class GeneralCleaner
  def initialize(options = {})
    @options = {
      :subject    => nil,
      :scope      => [],
      :execute    => false,
      :time_limit => Rails.env.local? ? nil : nil, # 最大処理時間(朝2時に実行したら6時には必ず終了させる)
      :verbose    => false,
      :batch_size => 1000,
    }.merge(options)
  end

  def call
    @start_time = Time.current
    @count = scope.count
    memo["前"] = scope.count

    if scope.respond_to?(:find_in_batches)
      # FIXME: find_in_batches の使い方を間違えている。複雑な条件のあとで find_in_batches ではなく find_in_batches のあとで複雑な条件を入れるのが正しい。
      scope.find_in_batches(batch_size: @options[:batch_size]) do |records|
        one_group(records)
        rows << @group
      end
    else
      one_group(scope)
      rows << @group
    end

    @end_time = Time.current

    memo["後"]   = scope.count
    memo["差"]   = memo["後"] - memo["前"]
    memo["開始"] = @start_time.to_fs(:ymdhms)
    memo["終了"] = @end_time.to_fs(:ymdhms)
    memo["時間"] = execution_duration.inspect

    AppLog.important(subject: subject, body: body)

    if @options[:verbose]
      puts subject
      puts body
    end
  end

  private

  def scope
    @options[:scope]
  end

  def one_group(records)
    @group = {}
    @group["日時"] = Time.current.to_fs(:ymdhms)
    @group["個数"] = records.size
    @group["成功"] = 0
    @group["失敗"] = 0
    if @options[:time_limit] && @options[:time_limit] <= (Time.current - @start_time)
      return
    end
    records.each { |e| one_record(e) }
    if @options[:verbose]
      puts
    end
    @group
  end

  def one_record(record)
    begin
      Retryable.retryable(on: ActiveRecord::Deadlocked) do
        if @options[:execute]
          # eager_load で抽出した場合は reload しないと memberships.size が 1 のため、片方の membership が残り、
          # ActiveRecord::InvalidForeignKey:
          #   Mysql2::Error: Cannot delete or update a parent row: a foreign key constraint fails (`shogi_web_test`.`swars_memberships`, CONSTRAINT `fk_rails_d0aeb0e4e3` FOREIGN KEY (`battle_id`) REFERENCES `swars_battles` (`id`))
          # のエラーになる
          method = :destroy!
          # if record.respond_to?(:destroy_for_general_cleaner)
          #   method = :destroy_for_general_cleaner
          # end
          record.public_send(method)
        end
        if @options[:verbose]
          print "."
        end
      end
      @group["成功"] += 1
    rescue ActiveRecord::RecordNotDestroyed, ActiveRecord::Deadlocked, ActiveRecord::InvalidForeignKey, Google::Apis::ClientError, Signet::AuthorizationError => error
      @group["失敗"] += 1
      errors["#{error.message} (#{error.class.name})"] += 1
    end
  end

  def subject
    av = []
    av << "[レコード削除]"
    if @options[:subject]
      av << "[#{@options[:subject]}]"
    end
    av << "#{memo["前"]} → #{memo["後"]} (#{memo["差"]}) #{execution_duration.inspect}"
    av * " "
  end

  def body
    [
      @options.except(:scope).to_t,
      memo.to_t,
      rows.to_t,
      errors.to_t,
    ].reject(&:blank?).join
  end

  def memo
    @memo ||= {}
  end

  def rows
    @rows ||= []
  end

  def errors
    @errors ||= Hash.new(0)
  end

  def execution_duration
    ActiveSupport::Duration.build(@end_time - @start_time)
  end
end
