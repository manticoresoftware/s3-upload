# Use a minimal base image
FROM alpine:latest

# Install required packages in a single layer
RUN apk add --no-cache s3cmd bash

# Set working directory
WORKDIR /upload

# Copy necessary files in a single step
COPY s3cfg /root/.s3cfg
COPY upload.sh /upload.sh

# Set execute permissions on the script
RUN chmod +x /upload.sh

# Set the entrypoint
ENTRYPOINT ["/upload.sh"]

# docker buildx build --progress=plain --push --platform linux/amd64,linux/arm64 --tag manticoresearch/upload .