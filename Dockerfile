# Use a minimal base image with curl and bash
FROM alpine:latest

# Install required packages
RUN apk add --no-cache s3cmd bash

# Copy the s3cmd config file
COPY s3cfg /root/.s3cfg

# Copy the upload script
COPY upload.sh /upload.sh
RUN chmod +x /upload.sh

# Set working directory
WORKDIR /upload

ENTRYPOINT ["/upload.sh"]
