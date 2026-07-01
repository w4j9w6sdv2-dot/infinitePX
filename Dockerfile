# Dockerfile per infinitePX su Render
# Immagine Ruby 2.7.8 ufficiale (Rails 5.2.3 compatibile)
FROM ruby:2.7.8-slim

# Dipendenze di sistema per Rails + PostgreSQL + Node + build tools
ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update -qq && apt-get install -y --no-install-recommends \
    build-essential \
    libpq-dev \
    postgresql-client \
    nodejs \
    npm \
    git \
    ca-certificates \
    libvips \
    && rm -rf /var/lib/apt/lists/*

# Aggiorna npm ad una versione compatibile con webpack 5
RUN npm install -g npm@8

# Imposta la working directory
WORKDIR /app

# Copia Gemfile e Gemfile.lock per installare le gemme in cache
COPY Gemfile Gemfile.lock ./

# Installa le gemme Ruby
RUN gem install bundler -v 2.1.4 \
    && bundle config set without 'development test' \
    && bundle install --jobs 4 --retry 3

# Copia il resto del codice
COPY . .

# Build del frontend (webpack) e precompilazione assets
RUN npm install \
    && npm run build \
    && bundle exec rake assets:precompile \
    && bundle exec rake assets:clean

# Esegui migrazioni DB al boot (idempotente)
# Lo script di avvio esegue migrate poi puma
COPY bin/render-start.sh /app/bin/render-start.sh
RUN chmod +x /app/bin/render-start.sh

EXPOSE 3000

CMD ["/app/bin/render-start.sh"]
