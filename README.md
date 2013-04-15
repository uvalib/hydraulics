# Welcome to Hydraulics

[![Build Status](https://travis-ci.org/uvalib-dcs/hydraulics.png?branch=master)](https://travis-ci.org/uvalib-dcs/hydraulics)

This gem is designed to be a plugin used within your own application


## Requirements

* Ruby 1.9.3
* Rails 3.2.13

If you are using an earlier version fo Fedora (i.e. 12), you must add to the Gemfile:

    gem 'execjs'
    gem 'therubyracer'

For the time being, you must include in the local app's Gemfile

    gem 'foreigner'

## Installation Instructions

    rails g validates_timeliness:install
is necessary to install a validation plugin utilized in Hydraulics models.

    rails g hydraulics
    
will install necessary database migrations.
