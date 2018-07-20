class SocialMediaInfo
  include ApplicationMemoryRecord
  memory_record [
    { key: :twitter, name: "Twitter", },
    { key: :google,  name: "Google",  },
    { key: :github,  name: "GitHub",  },
  ]
end

