# Docker Command Patterns

Common Docker patterns for development environments.

## Quick Reference

### Container Lifecycle

```bash
docker ps                    # Running containers
docker ps -a                 # All containers
docker logs -f <container>   # Follow logs
docker exec -it <container> bash  # Shell into container
```

### Cleanup

```bash
docker system prune -af      # Remove unused data
docker volume prune -f       # Remove unused volumes
docker builder prune -af     # Clear build cache
docker system df             # Show disk usage
```

### Development Databases

**PostgreSQL:**

```bash
# Start dev PostgreSQL
docker run -d --name postgres-dev \
    -e POSTGRES_PASSWORD=dev \
    -e POSTGRES_DB=devdb \
    -p 5432:5432 \
    -v postgres_dev_data:/var/lib/postgresql/data \
    postgres:latest

# Connect
docker exec -it postgres-dev psql -U postgres -d devdb
```

**Qdrant (Vector DB):**

```bash
docker run -d --name qdrant-dev \
    -p 6333:6333 -p 6334:6334 \
    -v qdrant_storage:/qdrant/storage \
    qdrant/qdrant:latest
# Dashboard: http://localhost:6333/dashboard
```

### Docker Compose

```bash
docker-compose up -d         # Start in background
docker-compose down          # Stop and remove
docker-compose logs -f       # Follow all logs
```

## Shell Functions Available

These functions are defined in `.zsh_docker_functions`:

- `pg_dev_start/stop/connect` - PostgreSQL management
- `qdrant_start/stop/backup` - Qdrant vector DB
- `jupyter_start/stop` - Jupyter Lab
- `dev_stack_start [web|ai|full]` - Full dev stacks
- `docker_overview` - System overview
