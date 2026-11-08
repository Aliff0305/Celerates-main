CREATE TABLE pembayaran (
id_pembayaran INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
id_pesanan INTEGER NOT NULL UNIQUE,
metode_pembayaran VARCHAR(50) NOT NULL,
status_pembayaran VARCHAR(30) NOT NULL DEFAULT 'menunggu'
CHECK (status_pembayaran IN ('menunggu', 'berhasil', 'gagal')),
tanggal_pembayaran TIMESTAMP,
CONSTRAINT fk_pembayaran_pesanan FOREIGN KEY (id_pesanan)
REFERENCES pesanan(id_pesanan) ON DELETE RESTRICT
);