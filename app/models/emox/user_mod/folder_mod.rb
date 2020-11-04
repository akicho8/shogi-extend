module Emox
  module UserMod
    concern :FolderMod do
      included do
        has_many :emox_folders, class_name: "Emox::Folder", dependent: :destroy

        FolderInfo.each do |e|
          has_one :"emox_#{e.key}_box", class_name: "::" + "emox/#{e.key}_box".classify, dependent: :destroy
        end

        after_create do
          FolderInfo.each do |e|
            send("create_emox_#{e.key}_box!")
          end
        end
      end

      def create_various_folders_if_blank
        FolderInfo.each do |e|
          send("emox_#{e.key}_box") || send("create_emox_#{e.key}_box!")
        end
      end
    end
  end
end
