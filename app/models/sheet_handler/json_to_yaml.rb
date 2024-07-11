module SheetHandler
  class JsonToYaml
    def call
      puts JSON.parse(Rails.root.join("config/google_account_json/shogi-web-development-06e32c3bc3b3.json").expand_path.read).to_yaml(line_width: -1)
    end
  end
end
