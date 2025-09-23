# -----------------------
# Build stage
# -----------------------
FROM node:20-alpine3.23 AS build

# Set working directory
WORKDIR /app

# Update Alpine packages and install dependencies
RUN apk update && apk upgrade && rm -rf /var/cache/apk/*

# Copy package files and install dependencies
COPY package*.json ./
RUN npm ci

# Copy source code and build
COPY . .
RUN npm run build

# -----------------------
# Production stage
# -----------------------
FROM nginx:1.26.1-alpine3.23

# Update Alpine packages
RUN apk update && apk upgrade && rm -rf /var/cache/apk/*

# Copy build artifacts from build stage
COPY --from=build /app/dist /usr/share/nginx/html

# Optional: copy custom nginx configuration if needed
# COPY nginx.conf /etc/nginx/conf.d/default.conf

# Expose port
EXPOSE 80

# Run nginx
CMD ["nginx", "-g", "daemon off;"]
