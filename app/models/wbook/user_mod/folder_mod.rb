module Wbook
  module UserMod
    concern :FolderMod do
      included do
        has_many :wbook_folders, class_name: "Wbook::Folder", dependent: :destroy

        FolderInfo.each do |e|
          has_one :"wbook_#{e.key}_box", class_name: "::" + "wbook/#{e.key}_box".classify, dependent: :destroy
        end

        after_create do
          FolderInfo.each do |e|
            send("create_wbook_#{e.key}_box!")
          end
        end
      end

      def wbook_create_various_folders_if_blank
        FolderInfo.each do |e|
          send("wbook_#{e.key}_box") || send("create_wbook_#{e.key}_box!")
        end
      end
    end
  end
end
