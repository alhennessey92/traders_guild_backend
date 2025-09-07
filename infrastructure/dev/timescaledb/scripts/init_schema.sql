-- Enable required extensions
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";  -- for UUID v4
CREATE EXTENSION IF NOT EXISTS pgcrypto;     -- for gen_random_uuid()
CREATE EXTENSION IF NOT EXISTS timescaledb;  -- for hypertables

-- =========================================================
-- USERS
-- =========================================================
CREATE TABLE users (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    email TEXT UNIQUE,
    apple_id TEXT UNIQUE,
    google_id TEXT UNIQUE,
    password_hash TEXT,  -- only used if email signup
    display_name TEXT,
    created_at TIMESTAMPTZ DEFAULT now(),
    last_login TIMESTAMPTZ
);

-- =========================================================
-- GUILDS
-- =========================================================
CREATE TABLE guilds (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name TEXT NOT NULL,
    description TEXT,
    owner_id UUID REFERENCES users(id) ON DELETE CASCADE,
    created_at TIMESTAMPTZ DEFAULT now()
);

-- Guild Roles: which users have which roles in which guilds
CREATE TABLE roles (
    id SERIAL PRIMARY KEY,
    name TEXT UNIQUE NOT NULL
);

-- Membership: which users belong to which guilds
CREATE TABLE guild_memberships (
    guild_id UUID REFERENCES guilds(id) ON DELETE CASCADE,
    user_id UUID REFERENCES users(id) ON DELETE CASCADE,
    role_id INT REFERENCES roles(id) NOT NULL DEFAULT 3, -- 'member' has id 3
    joined_at TIMESTAMPTZ DEFAULT now(),
    PRIMARY KEY (guild_id, user_id)
);

-- =========================================================
-- MARKET SYMBOLS
-- =========================================================
CREATE TABLE symbols (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    ticker TEXT UNIQUE NOT NULL,   -- e.g. AAPL, TSLA
    name TEXT
);

-- =========================================================
-- CHAT
-- =========================================================

-- Guild Single User Chat: 
CREATE TABLE guild_chat_messages (
    id BIGSERIAL PRIMARY KEY,
    ucid UUID UNIQUE DEFAULT gen_random_uuid(), -- Unique chat id  for a chat message
    guild_id UUID REFERENCES guilds(id) ON DELETE CASCADE,
    user_id UUID REFERENCES users(id) ON DELETE SET NULL,
    content TEXT NOT NULL,
    created_at TIMESTAMPTZ DEFAULT now()
);

-- Direct messages between two guild members
CREATE TABLE guild_direct_messages (
    id BIGSERIAL PRIMARY KEY,
    ucid UUID UNIQUE DEFAULT gen_random_uuid(), -- Unique message id
    guild_id UUID REFERENCES guilds(id) ON DELETE CASCADE,
    sender_id UUID REFERENCES users(id) ON DELETE SET NULL,
    receiver_id UUID REFERENCES users(id) ON DELETE SET NULL,
    content TEXT NOT NULL,
    created_at TIMESTAMPTZ DEFAULT now()
);

-- Symbol Chat:
CREATE TABLE symbol_chat_messages (
    id BIGSERIAL PRIMARY KEY,
    ucid UUID UNIQUE DEFAULT gen_random_uuid(), -- Unique chat id  for a chat message
    guild_id UUID REFERENCES guilds(id) ON DELETE CASCADE,
    user_id UUID REFERENCES users(id) ON DELETE SET NULL,
    symbol_id UUID REFERENCES symbols(id) ON DELETE CASCADE,
    content TEXT NOT NULL,
    created_at TIMESTAMPTZ DEFAULT now()
);



-- =========================================================
-- TICK DATA (hypertable)
-- =========================================================
CREATE TABLE ticks (
    symbol_id INT REFERENCES symbols(id) ON DELETE CASCADE,
    ts TIMESTAMPTZ NOT NULL,
    price NUMERIC(12,6) NOT NULL,
    volume BIGINT,
    PRIMARY KEY (symbol_id, ts)
);

-- Convert ticks to a hypertable
SELECT create_hypertable('ticks', by_range('ts'), if_not_exists => TRUE);
SELECT add_retention_policy('ticks', INTERVAL '10 days');

-- Continuous Aggregate to 1Min

CREATE MATERIALIZED VIEW ticks_1m
WITH (timescaledb.continuous) AS
SELECT
    time_bucket('1 minute', ts) AS bucket,
    symbol_id,
    first(price, ts) AS open,
    max(price) AS high,
    min(price) AS low,
    last(price, ts) AS close,
    sum(volume) AS volume
FROM ticks
GROUP BY symbol_id, bucket;

SELECT add_continuous_aggregate_policy('ticks_1m',
    start_offset => INTERVAL '1 day',
    end_offset   => INTERVAL '1 minute',
    schedule_interval => INTERVAL '1 minute'
);


-- Continuous Aggregate to 5Min
CREATE MATERIALIZED VIEW ticks_5m
WITH (timescaledb.continuous) AS
SELECT
    time_bucket('5 minutes', ts) AS bucket,
    symbol_id,
    first(price, ts) AS open,
    max(price) AS high,
    min(price) AS low,
    last(price, ts) AS close,
    sum(volume) AS volume
FROM ticks
GROUP BY symbol_id, bucket;

SELECT add_continuous_aggregate_policy('ticks_5m',
    start_offset => INTERVAL '1 day',
    end_offset   => INTERVAL '5 minute',
    schedule_interval => INTERVAL '5 minute'
);

-- Continuous Aggregate to 15Min
CREATE MATERIALIZED VIEW ticks_15m
WITH (timescaledb.continuous) AS
SELECT
    time_bucket('15 minutes', ts) AS bucket,
    symbol_id,
    first(price, ts) AS open,
    max(price) AS high,
    min(price) AS low,
    last(price, ts) AS close,
    sum(volume) AS volume
FROM ticks
GROUP BY symbol_id, bucket;
SELECT add_continuous_aggregate_policy('ticks_15m',
    start_offset => INTERVAL '1 day',
    end_offset   => INTERVAL '15 minute',
    schedule_interval => INTERVAL '15 minute'
);

-- Continuous Aggregate to 1Hour
CREATE MATERIALIZED VIEW ticks_1h
WITH (timescaledb.continuous) AS
SELECT
    time_bucket('1 hour', ts) AS bucket,
    symbol_id,
    first(price, ts) AS open,
    max(price) AS high,
    min(price) AS low,
    last(price, ts) AS close,
    sum(volume) AS volume
FROM ticks
GROUP BY symbol_id, bucket;
SELECT add_continuous_aggregate_policy('ticks_1h',
    start_offset => INTERVAL '1 day',
    end_offset   => INTERVAL '1 hour',
    schedule_interval => INTERVAL '1 hour'
);

