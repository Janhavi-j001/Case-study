# Multi-stage build for production
FROM node:18-alpine AS builder

WORKDIR /app
COPY backend/package*.json ./
RUN npm install --only=production && npm cache clean --force

# Production stage
FROM node:18-alpine AS production

# Create non-root user
RUN addgroup -g 1001 -S nodejs && adduser -S nodejs -u 1001

WORKDIR /app

# Copy dependencies
COPY --from=builder /app/node_modules ./node_modules
COPY backend/ .
COPY frontend/ ../frontend/

# Security: Remove unnecessary packages
RUN apk del --purge

# Change ownership
RUN chown -R nodejs:nodejs /app
USER nodejs

EXPOSE 3000

# Health check
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
  CMD node healthcheck.js

CMD ["node", "app.js"]