module Constants
  INFORMATION = {
"development" =>
  {
  "adapter" => "mysql2",
  "database" => "test",
  "hostname" => "localhost",
  "username" => "root",
  "password" => "webonise6186"
  }
}

  TOP_STRING = "# MySQL version 5.x
#   gem install mysql2
#
# This file contains database configuration for mysql2 gem
# To change the credentials or hostname, change it in here...
# This field is meant only for database\n"

  BOTTOM_STRING = "# You can add another yaml document below with a header and
# then list of keys and values

# Database:
#  adapter: sqlite3
#  database: db/development.sqlite3\n"

end
