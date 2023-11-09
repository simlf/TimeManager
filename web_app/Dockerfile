FROM node:18
ENV HOST=0.0.0.0

# Copiez le reste du code de votre projet dans le conteneur
COPY . /web_app

# Définissez le répertoire de travail dans le conteneur
WORKDIR /web_app


RUN chmod u+x ./entrypoint.sh

ENTRYPOINT [ "./entrypoint.sh" ]
