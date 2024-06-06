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

## API Documentation (cURL examples)

### Sign up
```shell
curl --location --request POST 'http://localhost:3000/api/v1/sign_up' \
--header 'Content-Type: application/json' \
--data-raw '{
    "user": {
        "full_name": "Rivel",
        "username": "rivelinojunior",
        "email": "r5@gmail.com",
        "password": "dd",
        "password_confirmation": "dd"
    }
}'
```

### Sign in
```shell
curl --location --request POST 'http://localhost:3000/api/v1/sign_in' \
--header 'Content-Type: application/json' \
--data-raw '{
    "email": "r5@gmail.com",
    "password": "dd"
}'
```