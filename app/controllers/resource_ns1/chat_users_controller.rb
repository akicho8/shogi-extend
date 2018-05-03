module ResourceNs1
  class ChatUsersController < ApplicationController
    include ModulableCrud::All

    def redirect_to_where
      [:resource_ns1, :chat_rooms]
    end
  end
end
