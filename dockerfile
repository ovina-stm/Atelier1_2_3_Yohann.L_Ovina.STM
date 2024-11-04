# Étape 1 : Génération du site statique
FROM ruby:3.0 as builder

# Installer les dépendances nécessaires
RUN apt-get update && apt-get install -y \
    git \
    build-essential

# Cloner le dépôt flatmdsite et construire le site
WORKDIR /app
COPY . .  # Copier tout le contenu du dépôt
RUN gem install bundler
RUN bundle install
RUN bundle exec flatmdsite build

# Étape 2 : Préparation du conteneur Nginx
FROM nginx:alpine

# Copier le site statique généré
COPY --from=builder /app/_site /usr/share/nginx/html

# Exposer le port
EXPOSE 80
