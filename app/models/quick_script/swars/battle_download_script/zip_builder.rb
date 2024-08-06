class QuickScript::Swars::BattleDownloadScript
  class ZipBuilder
    def initialize(base)
      @base = base
    end

    def to_blob
      Zip::OutputStream.write_buffer do |zos|
        @base.main_scope.each do |battle|
          zos.put_next_entry(entry_of(zos, battle))
          zos.write(content_of(battle))
        end
      end
    end

    private

    def entry_of(zos, battle)
      entry = Zip::Entry.new(zos, path_of(battle))
      entry.time = Zip::DOSTime.from_time(battle.battled_at)
      entry
    end

    def path_of(battle)
      av = []
      av << @base.swars_user.key
      if v = @base.structure_info.zip_path_format
        av << battle.battled_at.strftime(v)
      end
      av << "#{battle.key}.#{@base.format_info.key}"
      av.join("/")
    end

    def content_of(battle)
      content = battle.to_xxx(@base.format_info.key)
      if @base.encode_info.key == :"Shift_JIS"
        content = content.tosjis
      end
      content
    end
  end
end
