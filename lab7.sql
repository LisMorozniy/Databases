create table customers (
    id integer primary key,
    name varchar(255),
    birth_date date
);

create table accounts(
    account_id varchar(40) primary key ,
    customer_id integer references customers(id),
    currency varchar(3),
    balance float,
    "limit" float
);

create table transactions (
    id serial primary key ,
    date timestamp,
    src_account varchar(40) references accounts(account_id),
    dst_account varchar(40) references accounts(account_id),
    amount float,
    status varchar(20)
);

INSERT INTO customers VALUES (201, 'John', '2021-11-05');
INSERT INTO customers VALUES (202, 'Anny', '2021-11-02');
INSERT INTO customers VALUES (203, 'Rick', '2021-11-24');

INSERT INTO accounts VALUES ('NT10204', 201, 'KZT', 1000, null);
INSERT INTO accounts VALUES ('AB10203', 202, 'USD', 100, 0);
INSERT INTO accounts VALUES ('DK12000', 203, 'EUR', 500, 200);
INSERT INTO accounts VALUES ('NK90123', 201, 'USD', 400, 0);
INSERT INTO accounts VALUES ('RS88012', 203, 'KZT', 5000, -100);

INSERT INTO transactions VALUES (1, '2021-11-05 18:00:34.000000', 'NT10204', 'RS88012', 1000, 'committed');
INSERT INTO transactions VALUES (2, '2021-11-05 18:01:19.000000', 'NK90123', 'AB10203', 500, 'rollback');
INSERT INTO transactions VALUES (3, '2021-06-05 18:02:45.000000', 'RS88012', 'NT10204', 400, 'init');

---
CREATE ROLE accountant;
CREATE ROLE administrator;
CREATE ROLE support;

GRANT ALL PRIVILEGES ON accounts, transactions, customers TO administrator WITH GRANT OPTION;
GRANT INSERT, UPDATE, DELETE, SELECT ON accounts, customers TO support;
GRANT INSERT, SELECT ON transactions TO accountant;
GRANT SELECT ON accounts TO accountant;

CREATE USER Galina;
CREATE USER Vyacheslav;
CREATE USER Sergey;

GRANT administrator to Sergey;
GRANT support to Galina;
GRANT accountant to Vyacheslav;

REVOKE SELECT ON accounts FROM Vyacheslav;

ALTER TABLE customers
    ALTER COLUMN name SET NOT NULL;
ALTER TABLE customers
    ALTER COLUMN birth_date SET NOT NULL;
ALTER TABLE transactions
    ALTER COLUMN date SET NOT NULL;

CREATE UNIQUE INDEX curr on accounts (customer_id, currency);
CREATE INDEX bal ON accounts (currency, balance);

DO
$$
DECLARE
    ac_balance INT;
    ac_limit INT;
BEGIN;
    INSERT INTO transactions VALUES (4, CURRENT_TIMESTAMP, 'AB10203', 'NK90123', 50, 'init');
    SAVEPOINT sp;
    UPDATE accounts
    SET balance = balance - 50
    WHERE account_id = 'AB10203';
    UPDATE accounts
    SET balance = balance + 50
    WHERE account_id = 'NK90123';
    SELECT balance INTO ac_balance FROM accounts WHERE account_id = 'AB10203';
    SELECT accounts.limit INTO ac_limit FROM accounts WHERE account_id = 'AB10203';
    IF ac_balance < ac_limit THEN
        ROLLBACK TO SAVEPOINT sp;
        UPDATE transactions SET status = 'rollback' WHERE id = 4;
        COMMIT;
    ELSE
        UPDATE transactions SET status = 'committed' WHERE id = 4;
        COMMIT;
    END IF;
END;
$$



