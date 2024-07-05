## STEP 1 ##
FROM node:22-alpine AS builder

# Create app folder
RUN mkdir -p /usr/src/app

# Copy project files
COPY . /usr/src/app

# Set working directory to app folder
WORKDIR /usr/src/app

# Install dependencies
RUN npm install && npm run build

## STEP 2 ##
# nginx state for serving content
FROM nginx:alpine

# Set working directory to nginx asset directory
WORKDIR /usr/share/nginx/html

# Remove default nginx static assets
RUN rm -rf ./*

# Copy static assets from builder stage
COPY --from=builder /usr/src/app/dist /usr/share/nginx/html
COPY --from=builder /usr/src/app/nginx/nginx.conf /etc/nginx/nginx.conf

EXPOSE 80

# Containers run nginx with global directives and daemon off
ENTRYPOINT ["nginx", "-g", "daemon off;"]