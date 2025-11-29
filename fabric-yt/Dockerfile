
# Use the official Fabric image (Alpine-based)
# This image extends jimscard/fabric to include yt-dlp
# jimscard/fabric is built from the official fabric Dockerfile
# Install yt-dlp using pipx for isolated installation
# Switch to a non-root user for better security practices
# Use the official Fabric image (Alpine-based)
FROM jimscard/fabric:1.0
# Install system dependencies, create virtual environment, and install yt-dlp
RUN apk add --no-cache python3 py3-pip && \
    python3 -m venv /opt/venv && \
    /opt/venv/bin/pip install yt-dlp

# Ensure /opt/venv/bin is in PATH
ENV PATH="/opt/venv/bin:${PATH}"

# Create non-root user
RUN adduser -D appuser
# Switch to non-root user
USER appuser

# Switch to non-root user
USER appuser

# Verify installation
RUN yt-dlp --version

# Default command to start Fabric server
CMD ["fabric", "--serve"]
