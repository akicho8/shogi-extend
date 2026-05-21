module Swars
  class Battle
    concern :ExportMethods do
      class_methods do
        # rails r 'Swars::Battle.export_batch(start: 73724868)'
        def export_batch(options = {})
          options = {
            output_dir: "~/src/shogi/bioshogi/swars_battles",
            verbose: true,
            limit: nil,
            block_size: 100,
            start: nil,
          }.merge(options)

          output_dir = Pathname(options[:output_dir]).expand_path
          block_count = Swars::Battle.count.ceildiv(options[:block_size])
          Swars::Battle.in_batches(of: options[:block_size], start: options[:start]).each.with_index do |battles, i|
            battles.each do |battle|
              begin
                battle.to_all.each do |ext, body|
                  prefix = Digest::MD5.hexdigest(battle.key.to_s).slice(...2)
                  path = output_dir.join(prefix, battle.key, "#{battle.key}.#{ext}")
                  # if path.exist?
                  #   if options[:verbose]
                  #     print "."
                  #     STDOUT.flush
                  #   end
                  #   next
                  # end
                  path.dirname.mkpath
                  path.write(body)
                end
              rescue Bioshogi::BioshogiError => error
                output_dir.join("error_files.txt").write("#{battle.key} #{error}\n", mode: "a")
              end
            end
            ratio = i.fdiv(block_count) * 100.0
            if options[:verbose]
              puts "[#{i}/#{block_count}][#{ratio.round(2)}][id:#{battles.last.id}]"
            end
          end
        end
      end
    end
  end
end
