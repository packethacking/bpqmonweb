FROM nginx

# Copy the static files to the nginx directory
COPY . /usr/share/nginx/html
COPY ./nginx/nginx.conf /etc/nginx/conf.d/default.conf

