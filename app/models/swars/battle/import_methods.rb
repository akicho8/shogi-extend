module Swars
  class Battle
    concern :ImportMethods do
      class_methods do
        def setup(options = {})
          super

          if Rails.env.development?
            create!
          end

          if Rails.env.development?
            Importer::AllRuleImporter.new(user_key: "DevUser1").run
            if ENV["IT_IS_CALLED_THE_CRAWLER_AT_THE_TIME_OF_SETUP"]
              puts Crawler::ExpertCrawler.new.run.rows.to_t
            end
            find_each(&:rebuild)
          end

          if Rails.env.development?
            InitialImportForPaper.new.perform
          end
        end
      end
    end
  end
end
