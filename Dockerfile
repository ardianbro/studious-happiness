FROM ruby:2.6
RUN apt-get update -qq && apt-get install -y build-essential nodejs postgresql-client
RUN mkdir /myapp
WORKDIR /myapp

# istall npm
RUN curl -sL https://deb.nodesource.com/setup_12.x | bash -
RUN apt-get install -y nodejs

RUN node -v
RUN npm -v

COPY Gemfile /myapp/Gemfile
COPY Gemfile.lock /myapp/Gemfile.lock
RUN bundle install --verbose --jobs 20 --retry 5

# Install yarn using npm
RUN npm install -g yarn
RUN yarn install --check-files

COPY . /myapp

# Add a script to be executed every time the container starts.
COPY entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh
ENTRYPOINT ["entrypoint.sh"]
EXPOSE 3000

# Start the main process.
CMD ["rails", "server", "-b", "0.0.0.0"]