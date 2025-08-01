CREATE SCHEMA IF NOT EXISTS nonrelational;
SET search_path TO nonrelational, public;

CREATE TABLE employee (
  name TEXT PRIMARY KEY,
  certifications TEXT[]
);

INSERT INTO employee VALUES ('Bill', '{"CCNA", "ACSP", "CISSP"}');

SELECT * FROM employee;

SELECT name FROM employee WHERE certifications @> '{ACSP}';

SELECT certifications[1] FROM employee;

SELECT unnest(certifications) FROM employee;

SELECT name, unnest(certifications) FROM employee;

SELECT DISTINCT relkind FROM pg_class ORDER BY 1;

SELECT array_agg(DISTINCT relkind) FROM pg_class;

CREATE TABLE car_rental (
  id SERIAL PRIMARY KEY,
  time_span TSTZRANGE
);

INSERT INTO car_rental VALUES (DEFAULT, '[2016-05-03 09:00:00, 2016-05-11 12:00:00)');

SELECT * FROM car_rental WHERE time_span @> '2016-05-09 00:00:00'::timestamptz;

SELECT * FROM car_rental WHERE time_span @> '2018-06-09 00:00:00'::timestamptz;

INSERT INTO car_rental (time_span)
SELECT tstzrange(y, y + '1 day')
FROM generate_series('2001-09-01 00:00:00'::timestamptz, '2010-09-01 00:00:00'::timestamptz, '1 day') AS x(y);

SELECT * FROM car_rental WHERE time_span @> '2007-08-01 00:00:00'::timestamptz;

CREATE INDEX car_rental_idx ON car_rental USING GIST (time_span);

ALTER TABLE car_rental ADD EXCLUDE USING GIST (time_span WITH &&);

CREATE TABLE dart (
  dartno SERIAL,
  location POINT
);

INSERT INTO dart (location)
SELECT CAST('(' || random() * 100 || ',' || random() * 100 || ')' AS point)
FROM generate_series(1, 1000);

SELECT * FROM dart LIMIT 5;

SELECT * FROM dart WHERE location <@ '<(50, 50), 4>'::circle;

CREATE INDEX dart_idx ON dart USING GIST (location);

SELECT * FROM dart ORDER BY location <-> '(50, 50)'::point LIMIT 2;

CREATE TABLE printer (
  doc XML
);

CREATE TABLE friend (
  id SERIAL,
  data JSON
);

INSERT INTO friend (data) VALUES 
('{"first_name": "João", "last_name": "Silva", "email": "joao@email.com", "gender": "Male", "ip_address": "192.168.1.1"}'),
('{"first_name": "Maria", "last_name": "Santos", "email": "maria@email.com", "gender": "Female", "ip_address": "172.16.0.1"}'),
('{"first_name": "Pedro", "last_name": "Banks", "email": "pedro@email.com", "gender": "Male", "ip_address": "10.0.0.1"}'),
('{"first_name": "Ana", "last_name": "Costa", "email": "ana@email.com", "gender": "Female", "ip_address": "172.17.0.1"}'),
('{"first_name": "Carlos", "last_name": "Banks", "email": "carlos@email.com", "gender": "Male", "ip_address": "62.212.235.80"}');

SELECT * FROM friend ORDER BY 1 LIMIT 2;

SELECT id, jsonb(data::jsonb) FROM friend ORDER BY 1 LIMIT 1;

SELECT data->>'email' FROM friend ORDER BY 1 LIMIT 5;

SELECT data->>'first_name' || ' ' || (data->>'last_name') FROM friend ORDER BY 1 LIMIT 5;

SELECT data->>'first_name' FROM friend WHERE data->>'last_name' = 'Banks' ORDER BY 1;

SELECT data->>'first_name' FROM friend WHERE data::jsonb @> '{"last_name" : "Banks"}' ORDER BY 1;

CREATE INDEX friend_idx ON friend ((data->>'last_name'));

SELECT data->>'first_name' || ' ' || (data->>'last_name'), data->>'ip_address'
FROM friend
WHERE (data->>'ip_address')::inet <<= '172.0.0.0/8'::cidr
ORDER BY 1;

SELECT data->>'gender', COUNT(data->>'gender')
FROM friend
GROUP BY 1
ORDER BY 2 DESC;

SELECT '{"name" : "Jim", "name" : "Andy", "age" : 12}'::json;
SELECT '{"name" : "Jim", "name" : "Andy", "age" : 12}'::jsonb;

CREATE TABLE friend2 (
  id SERIAL,
  data JSONB
);

INSERT INTO friend2 SELECT * FROM friend;

CREATE INDEX friend2_idx ON friend2 USING GIN (data);

SELECT data->>'first_name'
FROM friend2
WHERE data @> '{"last_name" : "Banks"}'
ORDER BY 1;

CREATE TYPE drivers_license AS (
  state CHAR(2),
  id INTEGER,
  valid_until DATE
);

CREATE TABLE truck_driver (
  id SERIAL,
  name TEXT,
  license DRIVERS_LICENSE
);

INSERT INTO truck_driver VALUES (DEFAULT, 'Jimbo Biggins', ('PA', 175319, '2017-03-12'));

SELECT * FROM truck_driver;

SELECT (license).state FROM truck_driver;

CREATE TABLE fortune (
  line TEXT
);

INSERT INTO fortune VALUES 
('A bird in the hand is worth two in the bush'),
('The early bird catches the worm'),
('Don''t count your chickens before they hatch'),
('Actions speak louder than words'),
('Better late than never'),
('The cat is out of the bag'),
('Curiosity killed the cat'),
('Every cloud has a silver lining'),
('Rome wasn''t built in a day'),
('When in Rome, do as the Romans do'),
('Mop the floor carefully'),
('Mop up the mess quickly'),
('underdog'),
('Underdog saves the day'),
('So much for the plan we had');

SELECT * FROM fortune WHERE line = 'underdog';
SELECT * FROM fortune WHERE line = 'Underdog';
SELECT * FROM fortune WHERE lower(line) = 'underdog';

CREATE INDEX fortune_idx_text ON fortune (line);
CREATE INDEX fortune_idx_lower ON fortune (lower(line));

SELECT line FROM fortune WHERE line LIKE 'Mop%' ORDER BY 1;

CREATE INDEX fortune_idx_ops ON fortune (line text_pattern_ops);
CREATE INDEX fortune_idx_ops_lower ON fortune (lower(line) text_pattern_ops);

SELECT to_tsvector('I can hardly wait.');
SELECT to_tsquery('hardly & wait');

SELECT to_tsvector('I can hardly wait.') @@ to_tsquery('hardly & wait');

CREATE INDEX fortune_idx_ts ON fortune USING GIN (to_tsvector('english', line));

SELECT line FROM fortune WHERE line ILIKE '%verit%' ORDER BY 1;

CREATE EXTENSION IF NOT EXISTS pg_trgm;
CREATE INDEX fortune_idx_trgm ON fortune
USING GIN (line gin_trgm_ops);



SELECT show_limit();

SELECT line, similarity(line, 'So much for the plan')
FROM fortune
WHERE line % 'So much for the plan'
ORDER BY 2 DESC;

SELECT line FROM fortune WHERE line ~* '(^|[^a-z])cat' ORDER BY 1;

