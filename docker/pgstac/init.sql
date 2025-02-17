-- Create the postgis user if it doesn't exist
DO $$
BEGIN
  IF NOT EXISTS (SELECT FROM pg_roles WHERE rolname = 'postgis') THEN
    CREATE USER postgis WITH PASSWORD 'postgis';
  END IF;
END $$;

-- Create the pgstac database
CREATE DATABASE pgstac OWNER postgis;

-- Grant privileges
GRANT ALL PRIVILEGES ON DATABASE pgstac TO postgis;