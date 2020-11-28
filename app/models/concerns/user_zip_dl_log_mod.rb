module UserZipDlLogMod
  extend ActiveSupport::Concern

  # rails r 'tp User.sysop.swars_zip_dl_logs'
  included do
    has_many :swars_zip_dl_logs, dependent: :destroy, class_name: "Swars::ZipDlLog"
  end
end
