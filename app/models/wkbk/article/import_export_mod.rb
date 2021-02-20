module Wkbk
  class Article
    concern :ImportExportMod do
      class_methods do
        def setup(options = {})
          # unless exists?
          #   case
          #   when Rails.env.production?
          #     import_all(max: 1024)
          #   when Rails.env.staging?
          #     import_all(max: 1024)
          #   when Rails.env.development?
          #     import_all
          #   end
          # end
        end

        def export_all
          json = all.as_json({
                               only: [
                                 :key,
                                 :position,
                                 :init_sfen,
                                 :viewpoint,
                                 :title,
                                 :description,
                                 :direction_message,
                                 :difficulty,
                                 :tag_list,
                                 :mate_skip,
                                 :created_at,
                                 :updated_at,
                               ],
                               methods: [
                                 :lineage_key,
                               ],
                               include: {
                                 :user => {
                                   only: [
                                     :id,
                                     :key,
                                     :name,
                                   ],
                                 },
                                 :moves_answers => {
                                   only: [
                                     :moves_str,
                                   ],
                                 },
                               },
                             })

          body = json.to_yaml(line_width: -1)

          file = Rails.root.join("app/models/wkbk/#{name.demodulize.underscore.pluralize}.yml")
          FileUtils.mkdir_p(file.expand_path.dirname)
          file.write(body)
          puts "write: #{file} (#{count})"
        end

        def import_all(options = {})
          options = {
            max: (Rails.env.production? || Rails.env.staging?) ? 1024 : 1024,
          }.merge(options)

          persistent_records.take(options[:max]).each do |e|
            begin
              import_one(e, options)
            rescue => error
              tp e
              tp error
              raise error
            end
          end
        end

        def import_one(e, options = {})
          options = {
            user: User.sysop,
          }.merge(options)

          # if e[:user][:key] != "932ed39bb18095a2fc73e0002f94ecf1"
          #   return
          # end

          if Rails.env.production?
            if e[:user][:key] != "932ed39bb18095a2fc73e0002f94ecf1"
              return
            end
            user = User.find_by!(key: e[:user][:key])
          elsif Rails.env.staging?
            user = User.find_by(name: e[:user][:name]) || options[:user]
          else
            user = options[:user]
          end

          # record = user.wkbk_articles.find_or_initialize_by(key: e[:key])
          record = user.wkbk_articles.build
          record.assign_attributes(e.slice(*[
                                             :lineage_key,
                                             :init_sfen,
                                             :viewpoint,
                                             :title,
                                             :description,
                                             :direction_message,
                                             :difficulty,
                                             :mate_skip,
                                             :created_at,
                                             :updated_at,
                                           ]))

          # record.folder_key = "private"

          if true
            a = []
            if v = e[:source_author].presence
              a << "作者: #{v}"
            end
            if v = e[:source_media_name].presence
              a << "出典: #{v}"
            end
            if v = e[:source_media_url].presence
              a << "出典URL: #{v}"
            end
            if v = e[:source_published_on].presence
              a << "出典年月日: #{v}"
            end
            if a.present?
              record.description = (a.join("\n") + "\n\n" + record.description.to_s.strip).strip
            end
          end

          record.folder_key = :private
          record.save!

          record.moves_answers.clear
          e[:moves_answers].each do |e|
            record.moves_answers.create!(moves_str: e[:moves_str])
          end

          if e[:user][:key] == "932ed39bb18095a2fc73e0002f94ecf1"
            if e[:tag_list].include?("アヒル戦法")
              # record.update!(folder_key: "private")

              book = user.wkbk_books.find_or_initialize_by(title: "アヒル戦法問題集")
              book.folder_key = :private
              book.save!

              book.articles << record
            else
              if Rails.env.development?
                book = user.wkbk_books.find_or_initialize_by(title: "その他")
                book.folder_key = :public
                book.save!

                book.articles << record
              end
            end
          end

          print "."
        end

        private

        def persistent_file
          Rails.root.join("app/models/wkbk/#{name.demodulize.underscore.pluralize}.yml")
        end

        def persistent_records
          body = []
          if persistent_file.exist?
            body = YAML.load(persistent_file.read)
            puts "load: #{persistent_file} (#{body.count})"
          end
          body.collect(&:deep_symbolize_keys)
        end
      end
    end
  end
end
