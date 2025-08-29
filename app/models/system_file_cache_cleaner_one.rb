# cap production deploy:upload FILES=app/models/system_file_cache_cleaner_one.rb,app/models/system_file_cache_cleaner_all.rb
# rails r SystemFileCacheCleanerAll.call
class SystemFileCacheCleanerOne
  class << self
    def call(...)
      new(...).call
    end
  end

  attr_accessor :counts
  attr_accessor :params

  def initialize(params = {})
    @params = {
      :cutoff_time => 30.days.ago,
      :verbose     => Rails.env.local?,
    }.merge(params)

  end

  def call
    self.counts = Hash.new(0)
    if verbose?
      tp log_body
    end
    if target_dir.exist?
      target_dir.find do |path|
        if path.file?
          if path.extname == target_extname
            if params[:limit] && counts[:file_count] >= params[:limit]
              break
            end
            counts[:file_count] += 1
            if mtime_update_all?
              FileUtils.touch(path)
            end
            if path.mtime < cutoff_time
              counts[:target_count] += 1
              if execute?
                path.delete
              end
              unless path.exist?
                counts[:deleted_count] += 1
              end
            end
          end
        end
      end
    end
    if verbose?
      tp log_body
    end
    AppLog.important(subject: log_subject, body: log_body.to_t)
  end

  private

  def target_dir
    @params[:target_dir]
  end

  def target_extname
    @params[:target_extname]
  end

  def cutoff_time
    @params[:cutoff_time]
  end

  def verbose?
    @params[:verbose]
  end

  def mtime_update_all?
    @params[:mtime_update_all]
  end

  def execute?
    @params[:execute]
  end

  def log_subject
    [@params[:subject] || "掃除", counts[:deleted_count]].join(" ")
  end

  def log_body
    {
      "対象ディレクトリ"     => target_dir,
      "対象ファイル拡張子"   => target_extname,
      "条件: 最終更新日時 <" => cutoff_time.to_fs(:ymdhms),
      "全体のファイル数"     => counts[:file_count],
      "削除対象件数"         => counts[:target_count],
      "実際の削除数"         => counts[:deleted_count],
      "実行"                 => execute?,
    }
  end
end
