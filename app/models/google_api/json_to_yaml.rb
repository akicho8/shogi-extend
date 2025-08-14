module GoogleApi
  class JsonToYaml
    def call
      puts JSON.parse(Rails.root.join("config/google_account_json/local.json").expand_path.read).to_yaml(line_width: -1)
      puts JSON.parse(Rails.root.join("config/google_account_json/production.json").expand_path.read).to_yaml(line_width: -1)
    end
  end
end
