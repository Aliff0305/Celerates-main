CREATE TABLE detail_keranjang (
id_detail_keranjang INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
id_keranjang INTEGER NOT NULL,
id_produk INTEGER NOT NULL,
jumlah INTEGER NOT NULL CHECK (jumlah > 0),
CONSTRAINT fk_detail_keranjang FOREIGN KEY (id_keranjang)
REFERENCES keranjang(id_keranjang) ON DELETE CASCADE,
CONSTRAINT fk_detail_produk FOREIGN KEY (id_produk)
REFERENCES produk(id_produk) ON DELETE RESTRICT,
CONSTRAINT uq_keranjang_produk UNIQUE (id_keranjang, id_produk)
);