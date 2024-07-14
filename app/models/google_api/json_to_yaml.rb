module GoogleApi
  class JsonToYaml
    def call
      puts JSON.parse(Rails.root.join("config/google_account_json/shogi-web-development-2792594c71a6.json").expand_path.read).to_yaml(line_width: -1)
      puts JSON.parse(Rails.root.join("config/google_account_json/shogi-web-production-93737ceaabf3.json").expand_path.read).to_yaml(line_width: -1)
    end
  end
end
