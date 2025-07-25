FROM ruby:3.3.4

# Install system dependencies including MongoDB tools
RUN apt-get update -qq && \
    apt-get install -y \
        build-essential \
        libpq-dev \
        libvips \
        libcurl4-openssl-dev \
        libssl-dev \
        pkg-config \
        git \
        curl \
        redis-tools \
        gnupg \
        wget && \
    # Install MongoDB tools
    wget -qO - https://www.mongodb.org/static/pgp/server-7.0.asc | apt-key add - && \
    echo "deb [ arch=amd64,arm64 ] https://repo.mongodb.org/apt/ubuntu jammy/mongodb-org/7.0 multiverse" | tee /etc/apt/sources.list.d/mongodb-org-7.0.list && \
    apt-get update && \
    apt-get install -y mongodb-mongosh mongodb-database-tools && \
    rm -rf /var/lib/apt/lists/*

# Set working directory
WORKDIR /app

# Install bundler
RUN gem install bundler -v 2.4.22

# Copy dependency files first (for better caching)
COPY Gemfile Gemfile.lock ./
RUN bundle config set without 'production' && bundle install

# Copy application code
COPY . .

# Make entrypoint executable
RUN chmod +x ./bin/docker-entrypoint

# Expose the default Rails dev port
EXPOSE 3000

# Start with an entrypoint that handles setup
ENTRYPOINT ["./bin/docker-entrypoint"]