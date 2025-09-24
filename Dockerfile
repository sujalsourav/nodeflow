# Build stage
FROM node:20.14.0-alpine3.20 AS build
WORKDIR /app
COPY package*.json ./
RUN npm ci
COPY . .
RUN npm run build

# Production stage
# Using a verified official tag: mainline-alpine points to the latest NGINX on latest Alpine.
FROM nginx:mainline-alpine AS production

# Add this line to upgrade all packages to their latest patched versions.
RUN apk upgrade --no-cache

COPY --from=build /app/dist /usr/share/nginx/html
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
