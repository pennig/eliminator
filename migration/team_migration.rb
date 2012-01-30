require_relative '../model/connect.rb'
require_relative '../model/model.rb'
require_relative '../model/legacy_model.rb'

Team.truncate

Team.create(
    :name => "Arizona Cardinals",
    :short_name => "ARI",
    :stadium_name =>"University of Phoenix Stadium",
    :stadium_capacity => 63400,
    :conference => "NFC",
    :division => "West"
)
Team.create(
    :name => "Atlanta Falcons",
    :short_name => "ATL",
    :stadium_name =>"Georgia Dome",
    :stadium_capacity => 71228,
    :conference => "NFC",
    :division => "South"
)
Team.create(
    :name => "Carolina Panthers",
    :short_name => "CAR",
    :stadium_name =>"Bank of America Stadium",
    :stadium_capacity => 73778,
    :conference => "NFC",
    :division => "South"
)
Team.create(
    :name => "Chicago Bears",
    :short_name => "CHI",
    :stadium_name =>"Soldier Field",
    :stadium_capacity => 61500,
    :conference => "NFC",
    :division => "North"
)
Team.create(
    :name => "Dallas Cowboys",
    :short_name => "DAL",
    :stadium_name =>"Cowboys Stadium",
    :stadium_capacity => 80000,
    :conference => "NFC",
    :division => "East"
)
Team.create(
    :name => "Detroit Lions",
    :short_name => "DET",
    :stadium_name =>"Ford Field",
    :stadium_capacity => 65000,
    :conference => "NFC",
    :division => "North"
)
Team.create(
    :name => "Green Bay Packers",
    :short_name => "GB",
    :stadium_name =>"Lambeau Field",
    :stadium_capacity => 73128,
    :conference => "NFC",
    :division => "North"
)
Team.create(
    :name => "Minnesota Vikings",
    :short_name => "MIN",
    :stadium_name =>"Hubert H. Humphrey Metrodome",
    :stadium_capacity => 64111,
    :conference => "NFC",
    :division => "North"
)
Team.create(
    :name => "New Orleans Saints",
    :short_name => "NO",
    :stadium_name =>"Mercedes-Benz Superdome",
    :stadium_capacity => 76468,
    :conference => "NFC",
    :division => "South"
)
Team.create(
    :name => "New York Giants",
    :short_name => "NYG",
    :stadium_name =>"MetLife Stadium",
    :stadium_capacity => 82556,
    :conference => "NFC",
    :division => "East"
)
Team.create(
    :name => "Philadelphia Eagles",
    :short_name => "PHI",
    :stadium_name =>"Lincoln Financial Field",
    :stadium_capacity => 68532,
    :conference => "NFC",
    :division => "East"
)
Team.create(
    :name => "San Francisco 49ers",
    :short_name => "SF",
    :stadium_name =>"Candlestick Park",
    :stadium_capacity => 69732,
    :conference => "NFC",
    :division => "West"
)
Team.create(
    :name => "Seattle Seahawks",
    :short_name => "SEA",
    :stadium_name =>"CenturyLink Field",
    :stadium_capacity => 67000,
    :conference => "NFC",
    :division => "West"
)
Team.create(
    :name => "St. Louis Rams",
    :short_name => "STL",
    :stadium_name =>"Edward Jones Dome",
    :stadium_capacity => 66965,
    :conference => "NFC",
    :division => "West"
)
Team.create(
    :name => "Tampa Bay Buccaneers",
    :short_name => "TB",
    :stadium_name =>"Raymond James Stadium",
    :stadium_capacity => 65857,
    :conference => "NFC",
    :division => "South"
)
Team.create(
    :name => "Washington Redskins",
    :short_name => "WAS",
    :stadium_name =>"FedEx Field",
    :stadium_capacity => 82000,
    :conference => "NFC",
    :division => "East"
)
Team.create(
    :name => "Baltimore Ravens",
    :short_name => "BAL",
    :stadium_name =>"M&T Bank Stadium",
    :stadium_capacity => 71008,
    :conference => "AFC",
    :division => "North"
)
Team.create(
    :name => "Buffalo Bills",
    :short_name => "BUF",
    :stadium_name => "Ralph Wilson Stadium",
    :stadium_capacity => 73079,
    :conference => "AFC",
    :division => "East"
)
Team.create(
    :name => "Cincinnati Bengals",
    :short_name => "CIN",
    :stadium_name => "Paul Brown Stadium",
    :stadium_capacity => 65535,
    :conference => "AFC",
    :division => "North"
)
Team.create(
    :name => "Cleveland Browns",
    :short_name => "CLE",
    :stadium_name => "Cleveland Browns Stadium",
    :stadium_capacity => 73200,
    :conference => "AFC",
    :division => "North"
)
Team.create(
    :name => "Denver Broncos",
    :short_name => "DEN",
    :stadium_name => "Sports Authority Field at Mile High",
    :stadium_capacity => 76125,
    :conference => "AFC",
    :division => "West"
)
Team.create(
    :name => "Houston Texans",
    :short_name => "HOU",
    :stadium_name => "Reliant Stadium",
    :stadium_capacity => 71500,
    :conference => "AFC",
    :division => "South"
)
Team.create(
    :name => "Indianapolis Colts",
    :short_name => "IND",
    :stadium_name => "Lucas Oil Stadium",
    :stadium_capacity => 63000,
    :conference => "AFC",
    :division => "South"
)
Team.create(
    :name => "Jacksonville Jaguars",
    :short_name => "JAC",
    :stadium_name => "EverBank Field",
    :stadium_capacity => 67164,
    :conference => "AFC",
    :division => "South"
)
Team.create(
    :name => "Kansas City Chiefs",
    :short_name => "KC",
    :stadium_name => "Arrowhead Stadium",
    :stadium_capacity => 76416,
    :conference => "AFC",
    :division => "West"
)
Team.create(
    :name => "Miami Dolphins",
    :short_name => "MIA",
    :stadium_name => "Sun Life Stadium",
    :stadium_capacity => 75192,
    :conference => "AFC",
    :division => "East"
)
Team.create(
    :name => "New England Patriots",
    :short_name => "NE",
    :stadium_name => "Gillette Stadium",
    :stadium_capacity => 68756,
    :conference => "AFC",
    :division => "East"
)
Team.create(
    :name => "New York Jets",
    :short_name => "NYJ",
    :stadium_name =>"MetLife Stadium",
    :stadium_capacity => 82556,
    :conference => "AFC",
    :division => "East"
)
Team.create(
    :name => "Oakland Raiders",
    :short_name => "OAK",
    :stadium_name =>"O.co Coliseum",
    :stadium_capacity => 63026,
    :conference => "AFC",
    :division => "West"
)
Team.create(
    :name => "Pittsburgh Steelers",
    :short_name => "PIT",
    :stadium_name =>"Heinz Field",
    :stadium_capacity => 69050,
    :conference => "AFC",
    :division => "North"
)
Team.create(
    :name => "San Diego Chargers",
    :short_name => "SD",
    :stadium_name =>"Qualcomm Stadium",
    :stadium_capacity => 70561,
    :conference => "AFC",
    :division => "West"
)
Team.create(
    :name => "Tennessee Titans",
    :short_name => "TEN",
    :stadium_name =>"LP Field",
    :stadium_capacity => 69143,
    :conference => "AFC",
    :division => "South"
)
