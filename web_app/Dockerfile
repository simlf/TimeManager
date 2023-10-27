FROM node:18

WORKDIR /web_app

COPY package*.json ./

RUN npm install

COPY . .

EXPOSE 5173

RUN npm run dev --host
