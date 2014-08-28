module Constants
  INFORMATION = {
"development" => 
  {
  "adapter" => "mysql2", 
  "database" => "test",
  "hostname" => "localhost",
  "username" => "root",
  "password" => ""
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

  ROUTES_STRING = "#\n#\n# Define routes for your application here.
# Usage: goto '/controller/action' on ControllerName#action_name via: method
# Example:
# goto '/user/1/show' on UsersController#show via: get
# goto '/user/signin' on UsersController#signin via: post\n#\n#\n"
end