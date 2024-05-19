CREATE TABLE IF NOT EXISTS permission(
    id UUID     PRIMARY KEY DEFAULT gen_random_uuid(),
    name        VARCHAR(255) UNIQUE NOT NULL,
    description VARCHAR(255)
);

CREATE TABLE IF NOT EXISTS user_account(
    id          UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    first_name  VARCHAR(255) NOT NULL, 
    last_name   VARCHAR(255) NOT NULL,
    email       VARCHAR(255) UNIQUE NOT NULL,
    username    VARCHAR(255) UNIQUE NOT NULL,
    password    VARCHAR(255) NOT NULL,
    permission_id UUID REFERENCES permission(id) NOT NULL,
    -- Verified true when email is verified
    is_verified BOOLEAN NOT NULL DEFAULT FALSE,
    -- Unix timestamp
    last_verification_attempt TIMESTAMPTZ,
    -- Locked is true if admin locks the account
    is_locked   BOOLEAN NOT NULL DEFAULT FALSE
);

CREATE TABLE IF NOT EXISTS user_session (
    -- Lucia auth wont allow the use of UUID type here
    id          TEXT PRIMARY KEY, 
    expires_at  TIMESTAMPTZ NOT NULL,
    user_id    UUID REFERENCES user_account(id) NOT NULL
);

CREATE TABLE IF NOT EXISTS label(
    id          UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name        VARCHAR(255) NOT NULL,
    description VARCHAR(255),
    user_id     UUID REFERENCES user_account(id) NOT NULL
);

CREATE TABLE IF NOT EXISTS purchase(
    id          UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name        VARCHAR(255) NOT NULL,
    description VARCHAR(255),
    cost        NUMERIC(15,3) NOT NULL,
    date        TIMESTAMPTZ NOT NULL,
    user_id     UUID REFERENCES user_account(id) NOT NULL,
    label_id    UUID REFERENCES label(id) NOT NULL
);

CREATE TABLE IF NOT EXISTS subscription(
    id                  UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name                VARCHAR(255) NOT NULL,
    description         VARCHAR(255),
    cost                NUMERIC(15,3) NOT NULL,
    start_date          TIMESTAMPTZ NOT NULL,
    days_btwn_purchases INTEGER NOT NULL,
    is_active           BOOLEAN DEFAULT true NOT NULL,
    user_id             UUID REFERENCES user_account(id) NOT NULL,
    label_id            UUID REFERENCES label(id) NOT NULL
);