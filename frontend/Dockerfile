# Stage 1: Build Angular app
FROM node:20 AS builder

WORKDIR /app

# Copy package files first (for caching)
COPY package.json .
COPY package-lock.json .

# Install dependencies
RUN npm install

# Copy everything else
COPY . .

# Build for production
RUN npx ng build --configuration production


# Stage 2: Serve with Nginx
FROM nginx:alpine

# Remove default Nginx config
RUN rm -rf /etc/nginx/conf.d/*

# Copy custom Nginx config
COPY nginx.conf /etc/nginx/conf.d/default.conf

# Copy built Angular app
COPY --from=builder /app/dist/frontend/browser /usr/share/nginx/html

# Expose port 80
EXPOSE 80

# Run Nginx
CMD ["nginx", "-g", "daemon off;"]