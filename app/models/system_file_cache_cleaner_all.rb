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

    # ~/src/shogi/shogi-extend/public/system/talk
    SystemFileCacheCleanerOne.call({
        :subject          => "100日間使われていない発言mp3の削除",
        :target_dir       => Talk::Main.output_root_dir,
        :target_regexp    => /\A[\da-f]+\.mp3\z/i,
        :cutoff_time      => 100.days.ago,
        :mtime_update_all => false,
        :execute          => true,
      })

    # ~/src/shogi/shogi-extend/public/system/x-files
    SystemFileCacheCleanerOne.call({
        :subject          => "100日間使われていない盤面画像の削除",
        :target_dir       => MediaBuilder.output_root_dir,
        :target_regexp    => /\A[\da-f]+\.png\z/i,
        :cutoff_time      => 100.days.ago,
        :mtime_update_all => false,
        :execute          => true,
      })
  end
end
