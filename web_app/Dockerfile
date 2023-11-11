FROM node:18
ENV HOST=0.0.0.0

WORKDIR /web_app

# Copiez le reste du code de votre projet dans le conteneur
COPY . /web_app

# Définissez le répertoire de travail dans le conteneur


RUN chmod o+x entrypoint.sh

ENTRYPOINT [ "/web_app/entrypoint.sh" ]
