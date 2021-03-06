# NYC Bus and Train

Displays real-time information on NYC buses and trains.  Rails backend with Vue frontend.

## Requirements

* An [MTA GTFS API key](https://api.mta.info/#/landing)
* An [MTA Bus Time API key](http://bt.mta.info/wiki/Developers/Index)

See `config/secrets.yml.example`.

## Installation

```$sh
    bundle
    yarn install
    cp config/database.yml.example config/database.yml
    cp config/secrets.yml.example config/secrets.yml
    # make sure to add your API keys to secrets.yml
    rails db:create
    rails db:migrate
    rails db:seed
    rails s
```

Please note that seeding the database involves making an HTTP request for each of the MTA's ~15,000 bus stops, and will thus take quite some time to complete.  See `db/seeds.rb`.
