module Wkbk::Article::ImportExportMod
  extend ActiveSupport::Concern

  class_methods do
    def setup(options = {})
      unless exists?
        case
        when Rails.env.production?
          import_all(max: 1024)
        when Rails.env.staging?
          import_all(max: 1024)
        when Rails.env.development?
          import_all
        end
      end
    end

    def export_all
      json = all.as_json({
                           only: [
                             :key,
                             :init_sfen,
                             :time_limit_sec,
                             :difficulty_level,
                             :title,
                             :description,
                             :hint_desc,
                             :direction_message,
                             :owner_tag_list,
                             :source_author,
                             :source_media_name,
                             :source_media_url,
                             :source_published_on,
                             :mate_skip,
                             :created_at,
                             :updated_at,
                           ],
                           methods: [
                             :lineage_key,
                             :source_about_key,
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
      persistent_records.take(options[:max] || 10).each do |e|
        begin
          import_one(e, options)
        rescue => error
          p [error, e]
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
        user = User.find_by!(key: e[:user][:key])
      elsif Rails.env.staging?
        user = User.find_by(name: e[:user][:name]) || options[:user]
      else
        user = options[:user]
      end

      record = user.wkbk_articles.find_or_initialize_by(key: e[:key])
      record.assign_attributes(e.slice(*[
                                         :folder_key,
                                         :lineage_key,
                                         :init_sfen,
                                         :time_limit_sec,
                                         :difficulty_level,
                                         :title,
                                         :description,
                                         :hint_desc,
                                         :direction_message,
                                         :source_about_key,
                                         :source_author,
                                         :source_media_name,
                                         :source_media_url,
                                         :source_published_on,
                                         :mate_skip,
                                         :created_at,
                                         :updated_at,
                                       ]))

      record.folder_key = "private"

      if true
        a = []
        if v = e[:source_author].presense
          a << "作者: #{v}"
        end
        if v = e[:source_media_name].presense
          a << "出典: #{v}"
        end
        if v = e[:source_media_url].presense
          a << "出典URL: #{v}"
        end
        if v = e[:source_published_on].presense
          a << "出典年月日: #{v}"
        end
        if a.present?
          record.description = (a.join("\n") + "\n\n" + record.description).strip
        end
      end

      record.save!

      record.moves_answers.clear
      e[:moves_answers].each do |e|
        record.moves_answers.create!(moves_str: e[:moves_str])
      end

      if e[:user][:key] == "932ed39bb18095a2fc73e0002f94ecf1"
        if e[:owner_tag_list].include?("アヒル戦法")
          record.update!(folder_key: "public")

          book = user.wkbk_books.find_or_initialize_by(title: "アヒル戦法問題集")
          book.articles << record
          book.save!
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
