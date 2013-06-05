# Rentify coding exercise

## About

This is my solution to a coding exercise for a job application to [Rentify](https://www.rentify.com/)

It can be viewed on Heroku : http://rentify.herokuapp.com/


## Install

Get the code from GitHub

    git clone git@github.com:IanVaughan/rentify.git
    cd rentify


## Setup

    rbenv install 2.0.0-p195
    gem install bundler
    bundle

## Run

Run either via :

    shotgun

or just use the standard :

    rackup


## Test

Run the specs by :

    rspec spec

A benchmark of the search/sort can be performed via :

    ./script/benchmark

Command line :

* The API endpoints can be hit via curl, just for kicks :

        curl http://0.0.0.0:9292/find\?id\=Flat%201

        => {"id":"Flat 1","name":"Sizeable house","bedroom_count":2,"latitude":51.501,"longitude":-0.142}
