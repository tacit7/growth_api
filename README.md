# Growth API

Rails 7 API for a subscription platform with user management, analytics, and event tracking.

## Features

- User signup/login with JWT authentication
- Free and premium subscriptions
- Event tracking and analytics
- Admin dashboard with metrics
- Rate limiting and caching
- Background job processing

## Tech Stack

- Ruby 3.3.4 + Rails 7.2
- PostgreSQL (users, subscriptions)
- Redis (caching, rate limiting)
- Devise + JWT for authentication
- Sidekiq for background jobs
- RSpec for testing

## Quick Start

### Using Docker (Recommended)

```bash
git clone <your-repo-url>
cd growth_api

# Copy environment variables
cp .env.example .env

# Start services
docker-compose up --build

# Run migrations in another terminal
docker-compose exec web bin/rails db:create db:migrate

# Create admin user (optional)
docker-compose exec web bin/rails console
> User.create!(email: 'admin@example.com', password: 'password123', role: 'admin')
```

### Local Development

```bash
# Install dependencies
bundle install

# Setup database
bin/rails db:create db:migrate

# Start Redis and PostgreSQL locally
# Then start Rails
bin/rails server
```

## API Usage

### Authentication

All API endpoints use `/v1` prefix and require JWT tokens (except signup/login).

```bash
# Sign up
curl -X POST http://localhost:3000/v1/signup \
  -H "Content-Type: application/json" \
  -d '{"user":{"email":"test@example.com","password":"password123","name":"Test User"}}'

# Login (returns JWT token)
curl -X POST http://localhost:3000/v1/login \
  -H "Content-Type: application/json" \
  -d '{"user":{"email":"test@example.com","password":"password123"}}'

# Use token for protected routes
curl -H "Authorization: Bearer YOUR_JWT_TOKEN" http://localhost:3000/v1/profile
```

### Main Endpoints

| Method | Endpoint | Description | Auth Required |
|--------|----------|-------------|---------------|
| POST | `/v1/signup` | Create account | No |
| POST | `/v1/login` | Get JWT token | No |
| GET | `/v1/profile` | User details | Yes |
| POST | `/v1/subscribe` | Upgrade to premium | Yes |
| POST | `/v1/event` | Log user activity | Yes |
| GET | `/v1/admin/analytics/dashboard` | Admin metrics | Yes (Admin) |

### Event Logging

```bash
curl -X POST http://localhost:3000/v1/event \
  -H "Authorization: Bearer YOUR_JWT_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{"event_type":"Page View","event_data":{"page_path":"/dashboard","referrer":"google.com"}}'
```

Valid event types: `Page View`, `Click`, `Signup`, `Login`, `Logout`, `Subscribe`, `Unsubscribe`, `Upgrade Plan`, `Downgrade Plan`, `Delete Account`

## Testing

```bash
# Run all tests
bin/rails spec

# Run specific test files
bin/rails spec spec/requests/api/v1/
```

## Environment Variables

Required variables in `.env`:

```bash
DATABASE_URL=postgresql://postgres:postgres@localhost:5432/growth_development
REDIS_URL=redis://localhost:6379/0
DEVISE_JWT_SECRET_KEY=your_jwt_secret_here
SECRET_KEY_BASE=your_secret_key_base_here
```

Generate secrets with:
```bash
bin/rails secret
```

## Security Features

- Rate limiting (5 requests/minute per IP)
- Input validation and sanitization
- JWT token authentication
- Admin role verification
- SQL injection protection via ActiveRecord

## Development Notes

- Background jobs process events asynchronously
- User profiles cached for 10 minutes
- Admin analytics cached for 1 hour
- Rate limits stored in Redis with TTL

## Architecture

- **Controllers**: Handle HTTP requests, authentication, rate limiting
- **Services**: Business logic (SubscriptionService)
- **Jobs**: Background processing (EventLoggerJob)
- **Models**: Data layer with validations and associations
- **Serializers**: JSON API responses
