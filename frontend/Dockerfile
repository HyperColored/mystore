FROM node:16.20.0-alpine3.18 as builder
WORKDIR /app
#COPY ["package.json", "package-lock.json", "./"]
COPY . .
#RUN npm install && NODE_ENV=production VUE_APP_API_URL=http://localhost:8081 npm run build
RUN npm install && NODE_ENV=production npm run build

FROM nginx:stable-alpine
COPY --from=builder /app/dist /usr/share/nginx/html
COPY --from=builder /app/default.conf /etc/nginx/conf.d/default.conf
EXPOSE 80 
CMD ["nginx", "-g", "daemon off;"]