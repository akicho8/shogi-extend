module Swars
  class Battle
    concern :ExportMethods do
      class_methods do
        # rails r Swars::Battle.export_batch
        def export_batch(options = {})
          options = {
            output_dir: "~/src/shogi/bioshogi/swars_battles",
            verbose: true,
            limit: nil,
          }.merge(options)

          output_dir = Pathname(options[:output_dir]).expand_path
          all_count = Swars::Battle.count
          Swars::Battle.limit(options[:limit]).find_each.with_index do |battle, i|
            begin
              battle.to_all.each do |ext, body|
              prefix = Digest::MD5.hexdigest(battle.key.to_s).slice(...2)
              path = output_dir.join(prefix, battle.key, "#{battle.key}.#{ext}")
              if path.exist?
                if options[:verbose]
                  print "."
                  STDOUT.flush
                end
                next
              end
              path.dirname.mkpath
              path.write(body)
              ratio = i.fdiv(all_count) * 100
              if options[:verbose]
                puts "[#{i}/#{all_count}][#{ratio.round(2)}]: #{path.basename}"
              end
            end
            rescue Bioshogi::BioshogiError => error
              output_dir.join("error_files.txt").write("#{battle.key} #{error}\n" mode: "a")
            end
          end
        end
      end
    end
  end
end
