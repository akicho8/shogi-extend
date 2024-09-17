class QuickScript::Swars::CrossSearchScript
  class ZipBuilder
    FORMAT_KEY     = :kif
    README_INCLUDE = true

    def initialize(base)
      @base = base
    end

    def to_blob
      Zip::OutputStream.write_buffer do |zos|
        if README_INCLUDE
          zos.put_next_entry("README.txt")
          zos.write(@base.mail_body + "\n")
        end
        Swars::Battle.find(@base.found_ids).each do |battle|
          content = battle.to_xxx(format_info.key)
          EncodeInfo.each do |encode_info|
            zos.put_next_entry(entry_of(zos, battle, encode_info))
            zos.write(content.public_send(encode_info.transform_method))
          end
        end
      end
    end

    private

    def entry_of(zos, battle, encode_info)
      Zip::Entry.new(zos, path_of(battle, encode_info)).tap do |entry|
        entry.time = Zip::DOSTime.from_time(battle.battled_at)
      end
    end

    def path_of(battle, encode_info)
      av = []
      av << encode_info.key
      av << "#{battle.key}.#{format_info.key}"
      av.join("/")
    end

    def content_of(battle, encode_info)
      content = battle.to_xxx(format_info.key)
      content = content.public_send(encode_info.transform_method)
    end

    def format_info
      @format_info ||= Bioshogi::KifuFormatInfo.fetch(FORMAT_KEY)
    end
  end
end
