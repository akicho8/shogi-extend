module Wkbk::Article::ImportExportMod
  extend ActiveSupport::Concern

  class_methods do
    def setup(options = {})
      # if Rails.env.staging? || Rails.env.production? || Rails.env.development?
      #   unless exists?
      #     import_all
      #   end
      # end
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
      persistent_records.each do |e|
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

      if Rails.env.production?
        user = User.find_by!(key: e[:user][:key])
      elsif Rails.env.staging?
        user = User.find_by(name: e[:user][:name]) || options[:user]
      else
        user = options[:user]
      end

      record = user.wkbk_articles.find_or_initialize_by(key: e[:key])
      record.update!(e.slice(*[
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
                             ]))
      record.moves_answers.clear
      e[:moves_answers].each do |e|
        record.moves_answers.create!(moves_str: e[:moves_str])
      end
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
