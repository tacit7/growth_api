# Growth API

Ruby on Rails 7 API backend for a subscription-based analytics platform.
Supports user registration, JWT authentication, premium subscription upgrades, event logging, and a simple admin analytics dashboard.

## Features

- User signup and login (JWT-based)
- Subscription management (free and premium)
- Event tracking
- Admin dashboard
- Role-based access

## Tech Stack

- Ruby 3.3.4
- Rails 7
- PostgreSQL
- Devise + Devise-JWT
- RSpec, FactoryBot, and Faker
- Docker for development environment
- MongoDB for event logs
- Redis for caching
- Sidekiq for background log persistence

## Setup

```bash
# Clone the repository
git clone https://github.com/your_username/growth_api.git
cd growth_api

# Copy environment config
cp .env.example .env

# Build and run using Docker
docker-compose build
docker-compose up

# Setup the database
./bin/drails db:create db:migrate
```

## Running Tests

```bash
drails rspec spec
```

## Authentication

- JWT is issued on login
- Use the token in the `Authorization` header for protected routes:

```
Authorization: Bearer <token>
```

## API Endpoints

| Method | Endpoint     | Description                   |
| ------ | ------------ | ----------------------------- |
| POST   | /signup      | Register a new user           |
| POST   | /login       | Authenticate user and get JWT |
| GET    | /profile     | Return logged-in user details |
| POST   | /subscribe   | Upgrade user to premium       |
| DELETE | /unsubscribe | Upgrade user to premium       |
| POST   | /event       | Log user activity             |

## CI/CD

- GitHub Actions used for continuous integration and testing

## Documentation

- Basic API usage documented via [Postman](https://documenter.getpostman.com/view/29345048/2sB34oBcx7)

## Loom Walkthrough

A short video walkthrough is available at: [loom.com/your-video-url](https://loom.com/your-video-url)
