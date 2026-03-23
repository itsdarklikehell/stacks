# Monitoring Stack

Brings up Prometheus, Grafana, node-exporter, and cAdvisor for full-stack observability.

## Components

- **Prometheus** (port 9090): metrics collection and alerting
- **Grafana** (port 3000): dashboards and visualization
- **node-exporter**: host machine metrics (CPU, memory, disk, network)
- **cAdvisor**: container resource metrics

## Scrape Targets

- `localhost:9090` (Prometheus self)
- `localhost:9100` (node-exporter)
- `localhost:8080` (cAdvisor)
- `localhost:7352` (modelrelay metrics)
- Additional services can be added to `prometheus.yml`.

## Usage

Start the stack:

```bash
docker compose -f /media/rizzo/RAIDSTATION/stacks/STACKS/monitoring-stack/docker-compose.yml up -d
```

Stop:

```bash
docker compose -f /media/rizzo/RAIDSTATION/stacks/STACKS/monitoring-stack/docker-compose.yml down
```

## Grafana

- URL: http://localhost:3000
- Default admin password: `admin`
- Prometheus datasource pre-provisioned at http://localhost:9090

You can import dashboards for:
- Node exporter (Node Exporter Full)
- cAdvisor (Docker and container monitoring)
- modelrelay (custom metrics: request rate, error rate, cache hit rate, circuit breaker state)

## Data Persistence

Data stored in Docker volumes:
- `prometheus_data`
- `grafana_data`

## Notes

- All services use host networking to simplify access to localhost targets.
- Ensure ports 9090, 3000, 9100, 8080 are available.
