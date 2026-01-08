
# Use the official Fabric image (Alpine-based)
# This Dockerfile customizes the base fabric image to run as a non-root user
# for better security practices. The base image now includes yt-dlp.
FROM kayvan/fabric:latest

# Create non-root user
RUN adduser -D appuser

# Switch to non-root user
USER appuser

# Add healthcheck to monitor fabric server availability
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
    CMD wget --quiet --tries=1 --spider http://localhost:8080/ || exit 1

# Default command to start Fabric server
CMD ["fabric", "--serve"]
