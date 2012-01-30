require_relative '../../model/connect.rb'
require_relative '../../model/model.rb'
require_relative '../../model/legacy_model.rb'

User.truncate
UserInfo.truncate
$db_connection.run "ALTER TABLE users MODIFY COLUMN id INT UNSIGNED NOT NULL"
$db_connection.alter_table(:users) do
    drop_constraint(:PRIMARY,:type => :primary_key)
end
#force it to reload the model
class User < Sequel::Model(:users)
    self.db = $db_connection
end

LegacyUsers.order(:userid).where(:active => '1').each do |legacy_user|
    #puts "Migrating user #{legacy_user.name}..."
    if legacy_user.active == "1"
        active = 1
    else
        active = 0
    end

    begin
    user = User.create(
        :id => legacy_user.userid,
        :created_at => legacy_user.joindate,
        :username => legacy_user.name,
        :old_password => legacy_user.password,
        :email => legacy_user.email,
        :active => active
    )
    favorite_team = Team.first(:name => legacy_user.favteam)
    if not favorite_team.nil?
        favorite_team = favorite_team.id
    else
        favorite_team = nil
    end

    hated_team = Team.first(:name => legacy_user.hateteam)
    if not hated_team.nil?
        hated_team = hated_team.id
    else
        hated_team = nil
    end

    UserInfo.create(
        :user_id => user.id,
        :token => nil,
        :time_zone => legacy_user.timezone,
        :email_reminder => legacy_user.emailreminder,
        :favorite_team_id => favorite_team,
        :hated_team_id => hated_team
    )
    rescue Sequel::DatabaseError => e
        puts e
    end

end
$db_connection.alter_table(:users) do
    add_primary_key([:id])
end
$db_connection.run "ALTER TABLE users MODIFY COLUMN id INT UNSIGNED NOT NULL AUTO_INCREMENT"
$db_connection.run "ALTER TABLE users AUTO_INCREMENT=#{LegacyUsers.order(:userid).last.userid+1}"
