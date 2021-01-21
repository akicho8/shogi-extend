require "./setup"

user = User.sysop
user.permit_tag_list = "staff"
user.save!
user.reload
user.permit_tag_list        # => ["staff"]
tp user.as_json(only: [:id, :permit_tag_list])                # => {"id"=>1, "permit_tag_list"=>["staff"]}
# >> |-----------------+-----------|
# >> |              id | 1         |
# >> | permit_tag_list | ["staff"] |
# >> |-----------------+-----------|
