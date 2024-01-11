# FasTracks README (BE)
FasTracks provides a streamlined approach to workout playlist generation. Once the user selects genre preference and workout type, they are provided with an optimized playlist using metadata from Spotify, and criteria held in the FasTracks backend.

The project follows service-oriented architecture (SOA) and is divided into two different repositories:
  - [FasTracks-Frontend](https://github.com/FasTracks/FasTracks-FE) 
  - [FasTracks-Backend](https://github.com/FasTracks/FasTracks-BE) (you are here)

# FasTracks BE

This application consists of two repositories that utilize Spotify's API to create playlists for workouts. I don’t like working out, but it’s more fun and I have a better workout when I have a good playlist. But I don’t always like making playlists either. 

This is the backend repository that interacts with the Spotify API and delivers playlist data to the front end application. [FasTracks-FE](https://github.com/FasTracks/FasTracks-FE) provides the backend with authentication and user playlist preferences. [FasTracks-BE](https://github.com/FasTracks/FasTracks-BE) takes that input and, based on the parameters, sends requests to Spotify to generate a playlist inside the user's Spotify account. FasTracks-BE returns the important playlist details to FasTracks-FE in JSON format so the user can enjoy their new playlist. 

## Getting Started

The fastest way to start working out using FasTracks is to visit our deployed app [here](https://fastracks-62267ab898ea.herokuapp.com/).

If you would like to run the application locally, you will need Rails 7.X.X and to clone both [FasTracks-FE](https://github.com/FasTracks/FasTracks-FE) and [FasTracks-BE](https://github.com/FasTracks/FasTracks-BE), since the application follows service-oriented architecture. Within each repo, follow the steps below. 

1. `bundle install`
2. `rails db:{drop,create,migrate,seed}`
3. `bundle exec rspec`
4. `rails s`

Then, in your browser, visit `localhost:5000` and follow the prompts on screen. 

*Due to development constraints from Spotify, FasTracks is currently limited to invite-only users. Please message one of our contributors with to be added to our list of approved users. Please be sure to include the email address associated with your Spotify account. Alternatively, users may create their own app through [Spotify's developer portal](https://developer.spotify.com/documentation/web-api/concepts/apps) and reconfigure the Client ID and Client Secret in their local copy of the FE repo.*

### Prerequisites

For the fastest startup, we recommend visiting the deployed app [here](https://fastracks-62267ab898ea.herokuapp.com/).

However, if you prefer to get your hands dirty and understand our app, feel free to fork and clone this repo as well as [FasTracks-BE](https://github.com/FasTracks/FasTracks-BE). We recommend a basic understanding of the following concepts before diving in to our code:

- Ruby on Rails Applications
- Service oriented architecture
- Spotify API
- Oauth 2.0

Requirements for the software and other tools to build, test and push 
- Rails 7.X
- Ruby 3.2.2
- Spotify API V1

### Notes on Data Flow

*insert api calls and endpoints here*

### Installing

- Fork and clone these repos
  - [FasTracks-Frontend](https://github.com/FasTracks/FasTracks-FE) 
  - [FasTracks-Backend](https://github.com/FasTracks/FasTracks-BE) (you are here)

Ensure to install gems; this project uses bootstrap for mobile first design

`bundle install`<br>
`rails db:{create,migrate}`<br>
`rails dev:cache`
`update .env file `

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

This project is deployed using heroku [here](https://fastracks-62267ab898ea.herokuapp.com/) 
  
<img src="https://logowik.com/content/uploads/images/heroku8748.jpg" alt="drawing" width="100"/>

## Built With

- Spotify API
- Ruby on Rails
- Webmock

<img src="https://mikewilliamson.files.wordpress.com/2010/05/rails_on_ruby.jpg" alt="drawing" width="75"/>
<img src="https://storage.googleapis.com/pr-newsroom-wp/1/2018/11/Spotify_Logo_CMYK_Green.png" width="250"/>

## Contributing

Contributions are welcome and can be submitted by pull request. 

## Versioning

The current version of our application is live here on github. 

## Authors

  - **Edward Avery Rodriguez** - *[LinkedIn](https://www.linkedin.com/in/edward-avery-rodriguez/), [GitHub](https://github.com/TheAveryRodriguez)* 
  - **Kameron Kennedy** - *[LinkedIn](https://www.linkedin.com/in/kameron-kennedy-pe/), [GitHub](https://github.com/kameronk92)* 
  - **Scott DeVoss** - *[LinkedIn](https://www.linkedin.com/in/scott-devoss/), [GitHub](https://github.com/scottdevoss)* 
  - **Sooyung Kim** - *[LinkedIn](https://www.linkedin.com/in/sooyung-kim/), [GitHub](https://github.com/skim1027)* 
  - **Taylor Pubins** - *[LinkedIn](https://www.linkedin.com/in/trpubins/), [GitHub](https://github.com/trpubz)* 

## License

This project is not licensed and is open source. 

## Acknowledgments

  - Technical direction and consultation provded by [Jamison Ordway](https://github.com/jamisonordway) and [Chris Simmons](https://github.com/cjsim89)
  - This project completed by Mod 3 students at [Turing School of Software and Design](https://turing.edu/)
  - Little Caesar's Pizza for providing the most calories per dollar within 0.5 miles of [kameronk92's](https://github.com/kameronk92) house
