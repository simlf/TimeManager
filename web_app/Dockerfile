FROM node:18
ENV HOST=0.0.0.0

# Définissez le répertoire de travail dans le conteneur
WORKDIR /app

# Copiez le package.json et le package-lock.json dans le conteneur
COPY package*.json ./

# Installez les dépendances
RUN npm install

# Copiez le reste du code de votre projet dans le conteneur
COPY . .

# Exposez le port que Vite utilisera (par exemple 5173)
EXPOSE 5173

# Commande de démarrage pour Vite avec HMR
CMD ["npm", "run", "dev"]
