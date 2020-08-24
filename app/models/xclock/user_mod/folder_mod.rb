module Xclock
  module UserMod
    concern :FolderMod do
      included do
        has_many :xclock_folders, class_name: "Xclock::Folder", dependent: :destroy

        FolderInfo.each do |e|
          has_one :"xclock_#{e.key}_box", class_name: "::" + "xclock/#{e.key}_box".classify, dependent: :destroy
        end

        after_create do
          FolderInfo.each do |e|
            send("create_xclock_#{e.key}_box!")
          end
        end
      end

      def create_various_folders_if_blank
        FolderInfo.each do |e|
          send("xclock_#{e.key}_box") || send("create_xclock_#{e.key}_box!")
        end
      end
    end
  end
end
