FROM ruby:3.3.5

WORKDIR /app

RUN apt-get update -qq && apt-get install -y \
  nodejs \
  postgresql-client

COPY Gemfile Gemfile.lock ./
RUN bundle install

COPY . .

ENV RAILS_ENV=production

RUN bundle exec rails assets:precompile

EXPOSE 3000

CMD ["bundle", "exec", "rails", "server", "-b", "0.0.0.0"]
