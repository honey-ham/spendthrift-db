CREATE TABLE human(
    id          UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    first_name  VARCHAR(255) NOT NULL, 
    last_name   VARCHAR(255) NOT NULL,
    email       VARCHAR(255) UNIQUE NOT NULL,
    username    VARCHAR(255) UNIQUE NOT NULL,
    password    VARCHAR(255) NOT NULL
);

CREATE TABLE purchase(
    id          UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name        VARCHAR(255) NOT NULL,
    description VARCHAR(255),
    cost        NUMERIC(15,3) NOT NULL,
    date        TIMESTAMPTZ NOT NULL,
    human_id     UUID REFERENCES human (id) NOT NULL
);

CREATE TABLE subscription(
    id                  UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name                VARCHAR(255) NOT NULL,
    description         VARCHAR(255),
    cost                NUMERIC(15,3) NOT NULL,
    start_date          TIMESTAMPTZ NOT NULL,
    days_btwn_purchases INTEGER NOT NULL,
    is_active           BOOLEAN DEFAULT true NOT NULL,
    human_id             UUID REFERENCES human (id) NOT NULL
);

CREATE TABLE label(
    id          UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name        VARCHAR(255) NOT NULL,
    description VARCHAR(255),
    human_id     UUID REFERENCES human (id) NOT NULL
);

CREATE TABLE purchase_labels(
    label_id UUID REFERENCES label (id) NOT NULL,
    purchase_id UUID REFERENCES purchase (id) NOT NULL,
    PRIMARY KEY(label_id, purchase_id)
);

CREATE TABLE subscription_labels(
    label_id UUID REFERENCES label (id) NOT NULL,
    purchase_id UUID REFERENCES purchase (id) NOT NULL,
    PRIMARY KEY(label_id, purchase_id)
);