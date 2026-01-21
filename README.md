# MDV Infrastructure

Centralized infrastructure services for the MDV platform.

## Services

| Service | Port | Status |
|---------|------|--------|
| MySQL 8.0 | 3306 | Active |
| Redis | 6379 | Planned |
| Mailhog | 8025 | Planned |

## Quick Start

```bash
# Copy environment file
cp .env.example .env

# Start infrastructure
docker-compose up -d

# Verify MySQL is running
docker-compose ps
docker-compose logs mysql
```

## Connection from MDV Services

All MDV services connect to this infrastructure via Docker network:

```env
# In each mdv-* service .env file
DB_HOST=mdv-mysql
DB_PORT=3306
DB_DATABASE=goldharvest
DB_USERNAME=sail
DB_PASSWORD=password
```

**Alternative (host.docker.internal):**
```env
DB_HOST=host.docker.internal
DB_PORT=3306
```

## Network Architecture

```
┌─────────────────────────────────────────────────────────┐
│                    mdv-network                          │
├─────────────────────────────────────────────────────────┤
│                                                         │
│   ┌─────────────┐                                       │
│   │  mdv-mysql  │◄──────────────────────────────┐      │
│   │   :3306     │                               │      │
│   └─────────────┘                               │      │
│                                                 │      │
│   ┌─────────────┐  ┌─────────────┐  ┌─────────────┐   │
│   │mdv-filament │  │mdv-contacts │  │mdv-companies│   │
│   └─────────────┘  └─────────────┘  └─────────────┘   │
│                                                         │
└─────────────────────────────────────────────────────────┘
```

## Directory Structure

```
mdv-infrastructure/
├── docker-compose.yml    # Main compose file
├── .env.example          # Environment template
├── .env                  # Local environment (git ignored)
├── mysql/
│   └── init/             # SQL scripts (run on first start)
├── scripts/
│   └── backup.sh         # Backup script
└── README.md
```

## Backup

```bash
# Manual backup
./scripts/backup.sh

# Backup location
./backups/goldharvest_YYYYMMDD_HHMMSS.sql
```

## Useful Commands

```bash
# Check MySQL status
docker-compose exec mysql mysqladmin -u root -p status

# Access MySQL CLI
docker-compose exec mysql mysql -u sail -p goldharvest

# View logs
docker-compose logs -f mysql

# Restart MySQL
docker-compose restart mysql

# Stop all
docker-compose down

# Stop and remove volumes (DESTROYS DATA)
docker-compose down -v
```
