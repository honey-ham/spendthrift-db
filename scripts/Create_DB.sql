CREATE DATABASE spendthrift;

CREATE TABLE user(
    id          uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    first_name  varchar() NOT NULL, 
    last_name   varchar() NOT NULL,
    email       varchar() UNIQUE NOT NULL,
    username    varchar() UNIQUE NOT NULL,
    password    varchar() NOT NULL,
);
CREATE TABLE purchase();
CREATE TABLE subscription();
CREATE TABLE purchase_labels();
CREATE TABLE subscription_labels();
CREATE TABLE label();