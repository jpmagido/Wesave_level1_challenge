# Intro

We are building a peer-to-peer car rental service. Let's call it Getaround :)

Here is our plan:

- Let any car owner list her car on our platform
- Let any person (let's call him 'driver') book a car for given dates/distance

# Level 1

The car owner chooses a price per day and price per km for her car.
The driver then books the car for a given period and an approximate distance.

The rental price is the sum of:

- A time component: the number of rental days multiplied by the car's price per day
- A distance component: the number of km multiplied by the car's price per km


# Complementary Informations

* Hi there, was fun to work on this algo.
* I tried to keep it simple while making it scalable and understandable
* I guess I could use ExtractClass for Validator || PriceComputing but for now it's not mandatory IMO
* Don't hesitate to challenge me on my logic and architecture, I'll explain and share with pleasure :)

All Objects are located in `/lib`  
All Tests are located in `/spec`

* TESTING:  
`$ rspec level1` from `/wesave`  
`$ rspec` from `/wesave/level1`
  

* CODE ENFORCING:  
`$ rubocop`


* PERFORM Code:  
`$ ruby level1/main.rb`
