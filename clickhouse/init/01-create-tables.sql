-- MDV Centralized Logging Schema for ClickHouse

CREATE TABLE IF NOT EXISTS mdv_logs (
    trace_id UUID,
    span_id UUID,
    service LowCardinality(String),
    level LowCardinality(String),
    level_code UInt8,
    message String,
    context String,
    job_name Nullable(String),
    entity_type LowCardinality(Nullable(String)),
    entity_id Nullable(UInt64),
    duration_ms Nullable(UInt32),
    exception_class Nullable(String),
    exception_message Nullable(String),
    logged_at DateTime64(3)
) ENGINE = MergeTree()
PARTITION BY toYYYYMM(logged_at)
ORDER BY (trace_id, logged_at)
TTL toDateTime(logged_at) + INTERVAL 30 DAY;

-- Note: Both 'service' and 'entity_type' are kept for scalability.
-- service = microservice name (mdv-contacts, mdv-companies, mdv-activation)
-- entity_type = what is being processed (contact, company, campaign)
-- A service might process multiple entity types in the future.
CREATE TABLE IF NOT EXISTS mdv_trace_contexts (
    trace_id UUID,
    service LowCardinality(String),
    entity_type LowCardinality(String),
    entity_id UInt64,
    initiated_by LowCardinality(String),
    initiated_action String,
    status LowCardinality(String) DEFAULT 'active',
    started_at DateTime64(3),
    completed_at Nullable(DateTime64(3))
) ENGINE = MergeTree()
PARTITION BY toYYYYMM(started_at)
ORDER BY (trace_id)
TTL toDateTime(started_at) + INTERVAL 30 DAY;
