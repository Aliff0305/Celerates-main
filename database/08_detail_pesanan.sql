CREATE TABLE detail_pesanan (
id_detail_pesanan INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
id_pesanan INTEGER NOT NULL,
id_produk INTEGER NOT NULL,
jumlah INTEGER NOT NULL CHECK (jumlah > 0),
harga_satuan NUMERIC(12,2) NOT NULL CHECK (harga_satuan >= 0),
CONSTRAINT fk_detail_pesanan FOREIGN KEY (id_pesanan)
REFERENCES pesanan(id_pesanan) ON DELETE CASCADE,
CONSTRAINT fk_detail_pesanan_produk FOREIGN KEY (id_produk)
REFERENCES produk(id_produk) ON DELETE RESTRICT
);