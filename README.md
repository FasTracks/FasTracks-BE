# README

This README would normally document whatever steps are necessary to get the
application up and running.

Things you may want to cover:

* Ruby version

* System dependencies

* Configuration

* Database creation

* Database initialization

* How to run the test suite

* Services (job queues, cache servers, search engines, etc.)

* Deployment instructions

* ...
# FasTracks BE

This application consists of two repositories that utilize Spotify's API to create playlists for workouts. I don’t like working out, but it’s more fun and I have a better workout when I have a good playlist. But I don’t always like making playlists either. 

This app will take user input and create a unique playlist to boost the users workout. The app finds songs based on user-specified genre, duration and intensity, and pairs it with data from the Spotify API. The app then links the user to a new playlist with songs in varying beats per minute. 

This is the backend repository that interacts with the Spotify API and delivers data to the front end application. 

## Getting Started

These instructions will give you a copy of the project up and running on
your local machine for development and testing purposes. See deployment
for notes on deploying the project on a live system.

### Prerequisites

Requirements for the software and other tools to build, test and push 
- Rails 7.X
- Ruby 3.2.2
- Spotify API V1

### Using FasTracks

Click this link to see the deployed application.

### Installing

A step by step series of examples that tell you how to get a development
environment running

- Clone this repo
- Clone the FE repo

Gems Included: 

- gem "pry-rails"
- gem "rspec-rails"
- gem "factory_bot_rails"
- gem "faker"
- gem "shoulda-matchers"
- gem "capybara"
- gem "faraday"
- gem "webmock"
- gem "vcr"

    bundle install


And repeat

    until finished

End with an example of getting some data out of the system or using it
for a little demo

Request an access token:

curl -X POST "https://accounts.spotify.com/api/token" \
     -H "Content-Type: application/x-www-form-urlencoded" \
     -d "grant_type=client_credentials&client_id=your-client-id&client_secret=your-client-secret"


## Running the tests

Explain how to run the automated tests for this system

### Sample Tests

Explain what these tests test and why

    Give an example

### Style test

Checks if the best practices and the right coding style has been used.

    Give an example

## Deployment

Add additional notes to deploy this on a live system

## Built With

  - [Contributor Covenant](https://www.contributor-covenant.org/) - Used
    for the Code of Conduct
  - [Creative Commons](https://creativecommons.org/) - Used to choose
    the license

## Contributing

Please read [CONTRIBUTING.md](CONTRIBUTING.md) for details on our code
of conduct, and the process for submitting pull requests to us.

## Versioning

We use [Semantic Versioning](http://semver.org/) for versioning. For the versions
available, see the [tags on this
repository](https://github.com/PurpleBooth/a-good-readme-template/tags).

## Authors

  - **Billie Thompson** - *Provided README Template* -
    [PurpleBooth](https://github.com/PurpleBooth)

See also the list of
[contributors](https://github.com/PurpleBooth/a-good-readme-template/contributors)
who participated in this project.

Add LinkedIn Links*

## License

This project is licensed under the [CC0 1.0 Universal](LICENSE.md)
Creative Commons License - see the [LICENSE.md](LICENSE.md) file for
details

## Acknowledgments

  - Hat tip to anyone whose code is used
  - Inspiration
  - etc
