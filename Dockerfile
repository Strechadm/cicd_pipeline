FROM node:22-alpine

WORKDIR /opt

COPY package*.json ./
RUN npm install --production

COPY . .

EXPOSE 3000
CMD ["npm", "start"]