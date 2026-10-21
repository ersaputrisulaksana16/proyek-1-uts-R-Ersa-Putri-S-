-- ============================================================================
-- PROYEK 1 MANAJEMEN BASIS DATA
-- NAMA: ERSA
-- NIM : XXX099
-- ============================================================================

-- ----------------------------------------------------------------------------
-- SOAL 3: BIKIN SKEMA 'SALAM' DAN TABEL 'mahasiswas' DENGAN CONSTRAINTS
-- ----------------------------------------------------------------------------
CREATE SCHEMA IF NOT EXISTS SALAM;

-- Set search path ke skema SALAM
SET search_path TO SALAM, public;

CREATE TABLE SALAM.mahasiswas (
    mahasiswa_id SERIAL PRIMARY KEY,                        -- Primary Key
    nim VARCHAR(15) NOT NULL UNIQUE,                       -- Unique Constraint
    nama_lengkap VARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,                    -- Unique Constraint
    ipk NUMERIC(3,2) CHECK (ipk >= 0.00 AND ipk <= 4.00),  -- Check Constraint 1
    semester INT CHECK (semester >= 1 AND semester <= 14), -- Check Constraint 2
    status_aktif BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- FITUR UNIK / PEMBEDA DARI MAHASISWA LAIN:
-- 1. Tabel Audit Logs untuk mencatat log perubahan data
CREATE TABLE SALAM.audit_logs (
    log_id SERIAL PRIMARY KEY,
    action_type VARCHAR(20) NOT NULL,
    description TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 2. Trigger Function untuk merekam log pendaftaran mahasiswa baru
CREATE OR REPLACE FUNCTION SALAM.log_new_mahasiswa()
RETURNS TRIGGER AS $$
BEGIN
    INSERT INTO SALAM.audit_logs(action_type, description)
    VALUES ('INSERT', 'Mahasiswa baru berhasil ditambahkan: ' || NEW.nama_lengkap || ' (' || NEW.nim || ')');
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_mahasiswa_insert
AFTER INSERT ON SALAM.mahasiswas
FOR EACH ROW EXECUTE FUNCTION SALAM.log_new_mahasiswa();


-- ----------------------------------------------------------------------------
-- SOAL 4: PEMBUATAN USER DENGAN ROLE / HAK AKSES KHUSUS
-- ----------------------------------------------------------------------------

-- A. USER 1: backend_dev (Role: CRUD semua table di skema SALAM)
DROP USER IF EXISTS backend_dev;
CREATE USER backend_dev WITH PASSWORD 'BackendPass099!';
GRANT CONNECT ON DATABASE salam_db TO backend_dev;
GRANT USAGE ON SCHEMA SALAM TO backend_dev;
GRANT SELECT, INSERT, UPDATE, DELETE ON ALL TABLES IN SCHEMA SALAM TO backend_dev;
GRANT USAGE, SELECT ON ALL SEQUENCES IN SCHEMA SALAM TO backend_dev;
ALTER DEFAULT PRIVILEGES IN SCHEMA SALAM GRANT SELECT, INSERT, UPDATE, DELETE ON TABLES TO backend_dev;

-- B. USER 2: bi_dev (Role: Hanya read/select semua table/view di skema SALAM)
DROP USER IF EXISTS bi_dev;
CREATE USER bi_dev WITH PASSWORD 'BiDevPass099!';
GRANT CONNECT ON DATABASE salam_db TO bi_dev;
GRANT USAGE ON SCHEMA SALAM TO bi_dev;
GRANT SELECT ON ALL TABLES IN SCHEMA SALAM TO bi_dev;
ALTER DEFAULT PRIVILEGES IN SCHEMA SALAM GRANT SELECT ON TABLES TO bi_dev;

-- C. USER 3: data_engineer (Role: CREATE, MODIFY, DROP all objects, CRUD semua table)
DROP USER IF EXISTS data_engineer;
CREATE USER data_engineer WITH PASSWORD 'DataEngPass099!';
GRANT CONNECT ON DATABASE salam_db TO data_engineer;
GRANT ALL PRIVILEGES ON SCHEMA SALAM TO data_engineer;
GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA SALAM TO data_engineer;
GRANT ALL PRIVILEGES ON ALL SEQUENCES IN SCHEMA SALAM TO data_engineer;
ALTER DEFAULT PRIVILEGES IN SCHEMA SALAM GRANT ALL ON TABLES TO data_engineer;
ALTER DEFAULT PRIVILEGES IN SCHEMA SALAM GRANT ALL ON SEQUENCES TO data_engineer;