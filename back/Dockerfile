FROM 19.4.0-slim

WORKDIR /tutlayt
COPY package*.json ./
RUN npm install
COPY . .
RUN npm run build
ENTRYPOINT [ "node" ]
CMD [ "dist/main.js" ]
