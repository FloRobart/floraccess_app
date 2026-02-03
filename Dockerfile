# Étape 1 : Builder Flutter Web
FROM dart:stable AS builder
WORKDIR /app
COPY . .

# Installer Flutter SDK (branche stable) et précharger le SDK web
RUN apt-get update && \
    apt-get install -y git curl unzip xz-utils ca-certificates && \
    git clone --branch stable --depth 1 https://github.com/flutter/flutter.git /flutter && \
    chmod -R a+rX /flutter && \
    /flutter/bin/flutter --version && \
    /flutter/bin/flutter precache --web

# Activer Flutter Web et mettre le PATH
ENV PATH="/flutter/bin:/flutter/bin/cache/dart-sdk/bin:${PATH}"
RUN flutter config --enable-web

# Tenter de mettre à jour automatiquement les dépendances majeures (peut résoudre des incompatibilités)
RUN flutter pub upgrade --major-versions || true
RUN flutter pub get --offline || flutter pub get

# Build web
RUN flutter build web --release

# Étape 2 : Image finale avec NGINX
FROM nginx:alpine

# Remove default nginx website
RUN rm -rf /usr/share/nginx/html/*

# Copier le build Flutter web
COPY --from=builder /app/build/web /usr/share/nginx/html

# Optionnel : config nginx custom
COPY nginx.conf /etc/nginx/conf.d/default.conf

# Ajout d'un utilisateur non-root avec UID/GID fixes
RUN addgroup -g 1800 -S floraccessgroup && adduser -u 1800 -S floraccessuser -G floraccessgroup \
    && mkdir -p /run/nginx /var/cache/nginx /var/run /var/log/nginx \
    && chown -R floraccessuser:floraccessgroup /var/cache/nginx /var/run /var/log/nginx /run/nginx \
    && chmod 0755 /run/nginx
USER floraccessuser
