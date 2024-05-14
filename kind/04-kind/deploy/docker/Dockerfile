# Use an official Nginx image as a parent image
FROM nginx:stable-alpine-slim

# Remove the default Nginx configuration
RUN rm -f /etc/nginx/conf.d/default.conf

# Copy your custom Nginx configuration
COPY conf.d /etc/nginx/conf.d

# Copy static content (e.g., HTML, CSS, JS) to the Nginx document root
COPY html /usr/share/nginx/html

# Expose the port on which Nginx will listen
EXPOSE 80

# Define the command to run when the container starts
CMD ["nginx", "-g", "daemon off;"]