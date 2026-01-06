FROM ruby:3.3.5

ENV RAILS_ENV=production \
    BUNDLE_WITHOUT="development test" \
    BUNDLE_DEPLOYMENT=true

WORKDIR /app

# System deps
RUN apt-get update -qq && apt-get install -y \
  nodejs \
  npm \
  postgresql-client \
  && npm install -g yarn \
  && rm -rf /var/lib/apt/lists/*

# Gems
COPY Gemfile Gemfile.lock ./
RUN bundle install

# App
COPY . .

ARG SECRET_KEY_BASE
ENV SECRET_KEY_BASE=$SECRET_KEY_BASE

# Precompile assets
RUN bundle exec rails assets:precompile

EXPOSE 3000

# Puma là chuẩn production
CMD ["bundle", "exec", "puma", "-C", "config/puma.rb"]
