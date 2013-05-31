## Problem

Rentify advertises properties to rent. Sometimes when a user enquires about a
property it has already been rented out. When this happens we want to show that
user properties which are similar.

For a property to be similar it must be no more than 20km away and must not have
less bedrooms. Similar properties should be ordered by distance.

Rentify has a list of Property objects. Every Property has the attributes name,
bedroom_count, latitude and longitude.

Make a program to find similar properties. Requirements:

1. Search for property
2. List similar properties
3. Post your finished project on github

Example Property data:

    Flat 1 <= id? 'House1'?
    "name": "Sizeable house",
    "bedroom_count": 2,
    "latitude": 51.501000,
    "longitude": -0.142000

    Flat 2
    "name": "Trendy flat",
    "bedroom_count": 2,
    "latitude": 51.523778,
    "longitude": -0.205500

    Flat 3
    "name": "Flat with stunning view",
    "bedroom_count": 2,
    "latitude": 51.504444,
    "longitude": -0.086667

    Flat 4
    "name": "Unique flat",
    "bedroom_count": 1,
    "latitude": 51.538333,
    "longitude": -0.013333

    Flat 5 <= 'House2'?
    "name": "Isolated house",
    "bedroom_count": 1,
    "latitude": 50.066944,
    "longitude": -5.746944


## Initial thoughts (brain dump)

1. Parse Property from text file
    Assumption here is that if some data is presented in this way, more might be as well (Highly unlikely)
    And just for kicks

1. Read into a data store
    can just use memory here
    yaml format

1. Create class for data
    derive from base class or include module for lat/long calculations

1. Write Sinatra app (no need for heavier rails in this case)
    1. provide api call point so service can be used by other internal/external apps

         /nearest_to?name=flat 1?distance=20&bedroom=2
         => {flat2: lat long, flat3: lat long}

    1. root will serve search page
        a search box
        one big map
            centred on current lat/long
            shows all properties



1. Get Google Maps API key
1. Get Google Maps API ruby gem


1. Push up to heroku

