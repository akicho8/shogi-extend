module Swars
  module ZipDl
    class ZipBuilder
      def initialize(main_builder)
        @main_builder = main_builder
      end

      def to_zip_output_stream
        Zip::OutputStream.write_buffer do |zos|
          @main_builder.zip_dl_scope.each do |battle|
            if str = battle.to_xxx(@main_builder.kifu_format_info.key)
              path = []
              path << @main_builder.swars_user.key
              if @main_builder.zip_dl_structure_key == :date
                path << battle.battled_at.strftime("%Y-%m-%d")
              end
              path << "#{battle.key}.#{@main_builder.kifu_format_info.key}"
              path = path.join("/")

              entry = Zip::Entry.new(zos, path)
              entry.time = Zip::DOSTime.from_time(battle.battled_at)
              zos.put_next_entry(entry)

              if @main_builder.current_body_encode == "Shift_JIS"
                str = str.encode(@main_builder.current_body_encode)
              end
              zos.write(str)
            end
          end
        end
      end
    end
  end
end
