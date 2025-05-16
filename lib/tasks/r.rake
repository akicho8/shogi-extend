namespace :r do
  desc "Rスクリプトの一括実行"
  task :generate do
    Rails.root.join("app/models").glob("**/*.R") do |e|
      system "Rscript #{e}", exception: true
    end
    tp("production に即反映" => "cap production nuxt_side:static_upload")
  end
end
