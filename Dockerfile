FROM node:24-alpine

WORKDIR /opt

COPY package*.json ./
RUN npm install --production && npm cache clean --force

COPY . .

EXPOSE 3000
CMD ["npm", "start"]