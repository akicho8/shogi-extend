module Actb
  module UserMethods
    concern :FolderMethods do
      included do
        has_many :actb_folders, class_name: "Actb::Folder", dependent: :destroy

        FolderInfo.each do |e|
          has_one :"actb_#{e.key}_box", class_name: "::" + "actb/#{e.key}_box".classify, dependent: :destroy
        end

        after_create do
          FolderInfo.each do |e|
            send("create_actb_#{e.key}_box!")
          end
        end
      end

      def create_various_folders_if_blank
        FolderInfo.each do |e|
          send("actb_#{e.key}_box") || send("create_actb_#{e.key}_box!")
        end
      end
    end
  end
end
