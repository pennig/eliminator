require 'sequel'
require 'yaml'

config = YAML::load(File.open("config.yaml"))

$db_connection = Sequel.connect(
    :adapter => "mysql",
    :host => config["db"]["host"],
    :user => config["db"]["user"],
    :password => config["db"]["password"],
    :database => config["db"]["database"]
)
