# rails r SystemFileCacheCleanerAll.call
# RAILS_ENV=production bundle exec bin/rails r 'SystemFileCacheCleanerAll.call'
class SystemFileCacheCleanerAll
  class << self
    def call(...)
      new(...).call
    end
  end

  def call
    # これはしばらく touch でファイルを更新してから削除しないと Amazon 代がかかってしまう
    # なので数ヶ月後に execute: true にする

    # ~/src/shogi-extend/public/system/talk
    SystemFileCacheCleanerOne.call({
        :subject          => "発言mp3のキャッシュ削除",
        :target_dir       => Talk::Main.output_root_dir,
        :target_extname   => ".mp3",
        :cutoff_time      => 100.days.ago,
        :mtime_update_all => false,
        :execute          => true,
      })

    # x-files 以下は XfileCleaner で削除しているでいらない
    # SystemFileCacheCleanerOne.call({
    #     :subject        => "動画",
    #     :target_dir     => MediaBuilder.output_root_dir,
    #     :target_extname => ".mp3",
    #     :cutoff_time    => 30.days.ago,
    #   })
  end
end
