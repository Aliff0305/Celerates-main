CREATE TABLE pesanan (
id_pesanan INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
id_user INTEGER NOT NULL,
tanggal_pesanan TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
total_harga NUMERIC(12,2) NOT NULL DEFAULT 0 CHECK (total_harga >= 0),
status_pesanan VARCHAR(30) NOT NULL DEFAULT 'menunggu_pembayaran'
CHECK (status_pesanan IN
('menunggu_pembayaran', 'diproses', 'dikirim', 'selesai', 'dibatalkan')),
CONSTRAINT fk_pesanan_user FOREIGN KEY (id_user)
REFERENCES users(id_user) ON DELETE RESTRICT
);