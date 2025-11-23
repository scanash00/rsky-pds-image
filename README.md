# Environment Variables

This file documents all environment variables used in the rsky-pds project.

## Required Variables

### Database
- `DATABASE_URL`: PostgreSQL connection string
  - Format: `postgres://username:password@host:port/database_name`
  - Example: `postgres://postgres:postgres@localhost:5432/rsky_pds`

### Authentication
- `PDS_SERVICE_DID`: The DID (Decentralized Identifier) for this PDS service
- `PDS_JWT_KEY_K256_PRIVATE_KEY_HEX`: Hex-encoded K256 private key for JWT signing
- `PDS_REPO_SIGNING_KEY_K256_PRIVATE_KEY_HEX`: Hex-encoded K256 private key for repository signing
- `PDS_PLC_ROTATION_KEY_K256_PRIVATE_KEY_HEX`: Hex-encoded K256 private key for PLC operations
- `PDS_ADMIN_PASS`: Admin password for protected admin endpoints

### Email (Mailgun)
- `PDS_MAILGUN_API_KEY`: API key for Mailgun email service
- `PDS_MAILGUN_DOMAIN`: Your Mailgun domain
- `PDS_EMAIL_FROM_NAME`: Sender name for system emails
- `PDS_EMAIL_FROM_ADDRESS`: Sender email address for system emails
- `PDS_MODERATION_EMAIL_FROM_NAME`: Sender name for moderation emails
- `PDS_MODERATION_EMAIL_FROM_ADDRESS`: Sender email address for moderation emails
- `MAILGUN_REGION`: Mailgun region (e.g., "US", "EU")

## Optional Variables

### Database
- `DATABASE_MAX_CONNECTIONS`: Maximum number of database connections (default: 10)
- `DATABASE_TIMEOUT`: Connection timeout in seconds (default: 30)

### PLC (Peer-to-peer Linked Data)
- `PDS_DID_PLC_URL`: URL for the PLC directory service (default: "https://plc.directory")
- `PDS_HANDLE_BACKUP_NAMESERVERS`: Comma-separated list of backup nameservers
- `PDS_PLC_ROTATION_KEY_K256_PRIVATE_KEY_HEX`: Hex-encoded K256 private key for PLC rotation operations
- `PDS_REPO_SIGNING_KEY_K256_PRIVATE_KEY_HEX`: Hex-encoded K256 private key for repository signing
- `PDS_SERVICE_HANDLE_DOMAINS`: Comma-separated list of valid handle domains (e.g., ".test,.example.com")

### AWS
- `AWS_ENDPOINT`: Custom AWS endpoint URL (default: "localhost")
- `AWS_REGION`: AWS region (optional)
- `AWS_ACCESS_KEY_ID`: AWS access key ID (optional)
- `AWS_SECRET_ACCESS_KEY`: AWS secret access key (optional)

### Server Configuration
- `PDS_PORT`: Port to run the server on (default: 2583)
- `PDS_HOSTNAME`: Hostname of the PDS instance (default: "localhost")
- `PDS_VERSION`: Version of the PDS instance
- `PDS_PRIVACY_POLICY_URL`: URL to the privacy policy
- `PDS_TERMS_OF_SERVICE_URL`: URL to the terms of service
- `PDS_CONTACT_EMAIL_ADDRESS`: Contact email for the service
- `PDS_DEV_MODE`: Enable development mode (default: false)
- `PDS_ACCEPTING_REPO_IMPORTS`: Whether to accept repository imports (default: true)
- `PDS_BLOB_UPLOAD_LIMIT`: Maximum blob upload size in bytes (default: 5MB)
- `VERSION`: Application version (default: "0.3.0-beta.3")

### Identity & Authentication
- `PDS_SERVICE_DID`: The DID (Decentralized Identifier) for this PDS service
- `PDS_JWT_KEY_K256_PRIVATE_KEY_HEX`: Hex-encoded K256 private key for JWT signing
- `PDS_REPO_SIGNING_KEY_K256_PRIVATE_KEY_HEX`: Hex-encoded K256 private key for repository signing
- `PDS_PLC_ROTATION_KEY_K256_PRIVATE_KEY_HEX`: Hex-encoded K256 private key for PLC operations
- `PDS_RECOVERY_DID_KEY`: Recovery DID key
- `PDS_ID_RESOLVER_TIMEOUT`: Timeout for DID resolution in seconds (default: 3)
- `PDS_DID_CACHE_STALE_TTL`: Stale TTL for DID cache in seconds (default: 3600)
- `PDS_DID_CACHE_MAX_TTL`: Maximum TTL for DID cache in seconds (default: 86400)
- `PDS_ENABLE_DID_DOC_WITH_SESSION`: Enable DID document with session (default: false)
- `PDS_SERVICE_HANDLE_DOMAINS`: Comma-separated list of valid handle domains (e.g., ".test,.example.com")
- `PDS_HANDLE_BACKUP_NAMESERVERS`: Comma-separated list of backup nameservers
- `PDS_DID_PLC_URL`: URL for the PLC directory service (default: "https://plc.directory")
- `PDS_ENTRYWAY_DID`: Optional DID for the Entryway service (used for JWT audience validation)

### Invites & Access Control
- `PDS_INVITE_REQUIRED`: Whether invites are required (default: true)
- `PDS_INVITE_INTERVAL`: Invite code interval
- `PDS_INVITE_EPOCH`: Invite epoch number (default: 0)
- `PDS_ADMIN_PASS`: Admin password for protected endpoints
- `PDS_CRAWLERS`: Comma-separated list of allowed crawler user agents

### Subscriptions
- `PDS_MAX_SUBSCRIPTION_BUFFER`: Maximum subscription buffer size (default: 500)
- `PDS_REPO_BACKFILL_LIMIT_MS`: Maximum backfill time in milliseconds (default: 86400000)

### External Services
- `PDS_BSKY_APP_VIEW_URL`: URL for the Bluesky App View service (optional)
- `PDS_BSKY_APP_VIEW_DID`: DID of the Bluesky App View service (required if URL is set)
- `PDS_BSKY_APP_VIEW_CDN_URL_PATTERN`: CDN URL pattern for the Bluesky App View service (optional)
- `PDS_MOD_SERVICE_URL`: URL for the Moderation service (optional)
- `PDS_MOD_SERVICE_DID`: DID of the Moderation service (required if URL is set)
- `PDS_REPORT_SERVICE_URL`: URL for the Report service (optional, falls back to Moderation service if not set)
- `PDS_REPORT_SERVICE_DID`: DID of the Report service (required if URL is set and different from Moderation service)
- `PDS_MAILGUN_API_KEY`: API key for Mailgun email service
- `PDS_MAILGUN_DOMAIN`: Your Mailgun domain
- `PDS_EMAIL_FROM_NAME`: Sender name for system emails
- `PDS_EMAIL_FROM_ADDRESS`: Sender email for system emails
- `PDS_MODERATION_EMAIL_FROM_NAME`: Sender name for moderation emails
- `PDS_MODERATION_EMAIL_FROM_ADDRESS`: Sender email for moderation emails
- `MAILGUN_REGION`: Mailgun region (e.g., "US", "EU")

## Example .env File

```env
# Required
DATABASE_URL=postgres://postgres:postgres@localhost:5432/rsky_pds

# Server Configuration
PDS_PORT=2583
PDS_HOSTNAME=your.pds.hostname.com
PDS_VERSION=1.0.0
PDS_PRIVACY_POLICY_URL=https://your-domain.com/privacy
PDS_TERMS_OF_SERVICE_URL=https://your-domain.com/tos
PDS_CONTACT_EMAIL_ADDRESS=admin@yourdomain.com
PDS_DEV_MODE=false
PDS_ACCEPTING_REPO_IMPORTS=true
PDS_BLOB_UPLOAD_LIMIT=5242880  # 5MB

# Identity & Authentication
PDS_SERVICE_DID=did:plc:yourtrueserviceid
PDS_JWT_KEY_K256_PRIVATE_KEY_HEX=your_private_key_here
PDS_REPO_SIGNING_KEY_K256_PRIVATE_KEY_HEX=your_private_key_here
PDS_PLC_ROTATION_KEY_K256_PRIVATE_KEY_HEX=your_private_key_here
PDS_RECOVERY_DID_KEY=your_recovery_key_here
PDS_ID_RESOLVER_TIMEOUT=3
PDS_DID_CACHE_STALE_TTL=3600
PDS_DID_CACHE_MAX_TTL=86400
PDS_ENABLE_DID_DOC_WITH_SESSION=false
PDS_SERVICE_HANDLE_DOMAINS=.test,.example.com
PDS_HANDLE_BACKUP_NAMESERVERS=8.8.8.8,1.1.1.1
PDS_DID_PLC_URL=https://plc.directory

# Invites & Access Control
PDS_INVITE_REQUIRED=true
PDS_INVITE_INTERVAL=3600
PDS_INVITE_EPOCH=0
PDS_ADMIN_PASS=your_secure_password
PDS_CRAWLERS=googlebot,bingbot

# Subscriptions
PDS_MAX_SUBSCRIPTION_BUFFER=500
PDS_REPO_BACKFILL_LIMIT_MS=86400000

# External Services
# Bluesky AppView Service (optional)
PDS_BSKY_APP_VIEW_URL=https://bsky.social
PDS_BSKY_APP_VIEW_DID=did:plc:appview
PDS_BSKY_APP_VIEW_CDN_URL_PATTERN=https://cdn.bsky.app/img/{did}/{cid}/plain

# Moderation Service (optional)
PDS_MOD_SERVICE_URL=https://mod.bsky.social
PDS_MOD_SERVICE_DID=did:plc:mod

# Report Service (optional, falls back to Moderation service if not set)
# PDS_REPORT_SERVICE_URL=https://report.bsky.social
# PDS_REPORT_SERVICE_DID=did:plc:report

# Email Configuration
PDS_MAILGUN_API_KEY=your_mailgun_key
PDS_MAILGUN_DOMAIN=your.domain.com
PDS_EMAIL_FROM_NAME="Your PDS"
PDS_EMAIL_FROM_ADDRESS=noreply@yourdomain.com
PDS_MODERATION_EMAIL_FROM_NAME="Your PDS Moderation"
PDS_MODERATION_EMAIL_FROM_ADDRESS=moderation@yourdomain.com
MAILGUN_REGION=US

# AWS (if using S3 for storage)
AWS_ENDPOINT=localhost
AWS_REGION=us-east-1
AWS_ACCESS_KEY_ID=your_access_key_id
AWS_SECRET_ACCESS_KEY=your_secret_access_key
## Security Notes

1. Keep all private keys (`*_PRIVATE_KEY_*`) secure and never commit them to version control
2. Use strong, unique passwords for admin access
3. Consider using a secrets management service in production
4. The `.env` file should be in your `.gitignore`
5. For production, use environment-specific configuration and avoid hardcoding sensitive values
6. Rotate keys and passwords regularly
7. Use HTTPS for all API endpoints and web interfaces
