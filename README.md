# README

This README would normally document whatever steps are necessary to get the
application up and running.

Things you may want to cover:

- Ruby version

- System dependencies

- Configuration

- Database creation

- Database initialization

- How to run the test suite

- Services (job queues, cache servers, search engines, etc.)

- Deployment instructions

## Running Tests

If there is a container running, the following command can be used:

```bash
drails rspec spec
```

The project also can run tests with the following command:

```bash
  docker compose -rm test
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
