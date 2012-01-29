require 'sequel'
require 'yaml'

config = YAML::load(File.open("config.yaml"))

$legacy_db = Sequel.connect(
    :adapter => "mysql2",
    :host => config["legacy_db"]["host"],
    :user => config["legacy_db"]["user"],
    :password => config["legacy_db"]["password"],
    :database => config["legacy_db"]["database"]
)
