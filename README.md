# Proyek 1 - Manajemen Basis Data (UTS)

Repository ini berisi implementasi kontainerisasi **PostgreSQL** dan **pgAdmin4** menggunakan **Docker Compose**, serta skrip inisialisasi basis data untuk skema `SALAM` dan pengaturan *Role-Based Access Control* (RBAC).

---

## Informasi Mahasiswa
* **Nama:** R Ersa Putri Sulaksana
* **NIM :** 1247050099
* **Mata Kuliah:** Manajemen Basis Data
* **Tahun Akademik:** 2026/2027

---

## Konfigurasi Port & Service

| Service | Nama Kontainer | Port Internal | Port Eksternal | Environment File |
| :--- | :--- | :--- | :--- | :--- |
| **PostgreSQL 15** | `postgres_ersa` | `5432` | **`22099`** | `.env` |
| **pgAdmin4** | `pgadmin_ersa` | `80` | **`44099`** | `.env` |

> **Catatan Pengaturan Port:** Port eksternal menggunakan kombinasi $22XXX$ untuk PostgreSQL (`22099`) dan $44XXX$ untuk pgAdmin4 (`44099`), sesuai dengan 3 digit terakhir NIM (**099**).

---

## Struktur Project

```text
mbd-proyek1-ersa/
├── .env                  # Variabel lingkungan (credential & port)
├── docker-compose.yml    # Konfigurasi orkestrasi Docker
├── ersa.sql              # Skrip SQL DDL, Constraints, Trigger, & Role Management
└── README.md             # Dokumentasi proyek
