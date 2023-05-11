# public/system/x-files 以下の読み出しがない "_" をファイル名に含まないファイルを削除する
# rails r XfilesCleanup.new.call

class XfilesCleanup
  def initialize(options = {})
    @options = {
      :execute    => false,
      :expires_in => Rails.env.production? ? 90.days : 0.days,
    }.merge(options)
  end

  def call
    @target_files = []
    @skip_files = []
    @free_changes = FreeSpace.new.call do
      MediaBuilder.output_root_dir.find(&method(:file_process))
    end
    SystemMailer.notify(fixed: true, subject: subject, body: body).deliver_later
  end

  private

  def file_process(file)
    if file.file?
      if file.atime <= @options[:expires_in].seconds.ago
        if file.basename.to_s.include?("_") # 2_20210824130750_1024x768_8s.png のようなファイルは除く
          @skip_files << file_info(file)
        else
          FileUtils.rm_f(file, noop: !@options[:execute])
          @target_files << file_info(file)
        end
      end
    end
  end

  def subject
    [
      "x-files 以下削除",
      "#{@target_files.size}個",
      @free_changes.join("→"),
      "(除#{@skip_files.size}個)",
    ].join(" ")
  end

  def body
    [
      "▼オプション",
      @options.to_t,
      "",
      "▼削除したファイル",
      @target_files.to_t,
      "",
      "▼削除すると危険かもしれないファイル",
      @skip_files.to_t,
    ].compact.collect(&:strip).join("\n")
  end

  def file_info(file)
    { file: file, accessed_at: file.atime.strftime("%F %T") }
  end
end
