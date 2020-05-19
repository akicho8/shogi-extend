module Actb
  module UserMod
    concern :FolderMod do
      included do
        cattr_accessor(:folder_keys) { [:active, :draft, :trash] }

        has_many :folders, class_name: "Actb::Folder", dependent: :destroy

        folder_keys.each do |key|
          has_one :"actb_#{key}_box", class_name: "::" + "actb/#{key}_box".classify, dependent: :destroy
        end

        after_create do
          folder_keys.each do |key|
            send("create_actb_#{key}_box!")
          end
        end
      end

      def create_various_folders_if_blank
        folder_keys.each do |key|
          send("actb_#{key}_box") || send("create_actb_#{key}_box!")
        end
      end
    end
  end
end
