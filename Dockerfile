FROM node:23-alpine as builder

WORKDIR /app

COPY package.json package-lock.json ./

RUN npm ci

COPY . .

RUN npm run build

FROM nginx:stable-alpine

# remove default static content
RUN rm -rf /usr/share/nginx/html/*

# copy built files
COPY --from=builder /app/dist /usr/share/nginx/html
# expose port 80
EXPOSE 80
# run nginx in foreground
CMD ["nginx", "-g", "daemon off;"]
