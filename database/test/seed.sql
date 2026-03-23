 CREATE USER regular_user WITH PASSWORD 'regular_user';
 GRANT CONNECT ON DATABASE demons_postgres TO regular_user;
 GRANT SELECT, INSERT, UPDATE, DELETE ON ALL TABLES IN SCHEMA public TO regular_user;
 GRANT USAGE, SELECT ON ALL SEQUENCES IN SCHEMA public TO regular_user;