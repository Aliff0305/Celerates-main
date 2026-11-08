CREATE TABLE pengiriman (
id_pengiriman INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
id_pesanan INTEGER NOT NULL UNIQUE,
jenis_pengiriman VARCHAR(30) NOT NULL
CHECK (jenis_pengiriman IN ('kurir_desa', 'ekspedisi')),
alamat_tujuan TEXT NOT NULL,
nama_kurir VARCHAR(100),
nomor_resi VARCHAR(100),
status_pengiriman VARCHAR(30) NOT NULL DEFAULT 'menunggu'
CHECK (status_pengiriman IN
('menunggu', 'diproses', 'dikirim', 'diterima')),
CONSTRAINT fk_pengiriman_pesanan FOREIGN KEY (id_pesanan)
REFERENCES pesanan(id_pesanan) ON DELETE RESTRICT
);