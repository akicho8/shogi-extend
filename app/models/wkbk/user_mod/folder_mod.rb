module Wkbk
  module UserMod
    concern :FolderMod do
      included do
        has_many :wkbk_folders, class_name: "Wkbk::Folder", dependent: :destroy

        FolderInfo.each do |e|
          has_one :"wkbk_#{e.key}_box", class_name: "::" + "wkbk/#{e.key}_box".classify, dependent: :destroy
        end

        after_create do
          FolderInfo.each do |e|
            send("create_wkbk_#{e.key}_box!")
          end
        end
      end

      def wkbk_create_various_folders_if_blank
        FolderInfo.each do |e|
          send("wkbk_#{e.key}_box") || send("create_wkbk_#{e.key}_box!")
        end
      end

      def wkbk_folder_for(key)
        public_send("wkbk_#{key}_box")
      end
    end
  end
end
