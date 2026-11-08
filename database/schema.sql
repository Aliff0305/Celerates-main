--
-- PostgreSQL database dump
--

\restrict qiKxrK7VlzLzeq9KBjN1LhjIyNp4bWVHZ88bgsEar3lO4bRhNFbw9cudPdPn5UZ

-- Dumped from database version 18.6
-- Dumped by pg_dump version 18.6

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET transaction_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: public; Type: SCHEMA; Schema: -; Owner: -
--

-- *not* creating schema, since initdb creates it


--
-- Name: SCHEMA public; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON SCHEMA public IS '';


SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: detail_keranjang; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.detail_keranjang (
    id_detail_keranjang integer NOT NULL,
    id_keranjang integer NOT NULL,
    id_produk integer NOT NULL,
    jumlah integer NOT NULL,
    CONSTRAINT detail_keranjang_jumlah_check CHECK ((jumlah > 0))
);


--
-- Name: detail_keranjang_id_detail_keranjang_seq; Type: SEQUENCE; Schema: public; Owner: -
--

ALTER TABLE public.detail_keranjang ALTER COLUMN id_detail_keranjang ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.detail_keranjang_id_detail_keranjang_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: detail_pesanan; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.detail_pesanan (
    id_detail_pesanan integer NOT NULL,
    id_pesanan integer NOT NULL,
    id_produk integer NOT NULL,
    jumlah integer NOT NULL,
    harga_satuan numeric(12,2) NOT NULL,
    CONSTRAINT detail_pesanan_harga_satuan_check CHECK ((harga_satuan >= (0)::numeric)),
    CONSTRAINT detail_pesanan_jumlah_check CHECK ((jumlah > 0))
);


--
-- Name: detail_pesanan_id_detail_pesanan_seq; Type: SEQUENCE; Schema: public; Owner: -
--

ALTER TABLE public.detail_pesanan ALTER COLUMN id_detail_pesanan ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.detail_pesanan_id_detail_pesanan_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: kategori; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.kategori (
    id_kategori integer NOT NULL,
    nama_kategori character varying(100) NOT NULL
);


--
-- Name: kategori_id_kategori_seq; Type: SEQUENCE; Schema: public; Owner: -
--

ALTER TABLE public.kategori ALTER COLUMN id_kategori ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.kategori_id_kategori_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: keranjang; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.keranjang (
    id_keranjang integer NOT NULL,
    id_user integer NOT NULL,
    tanggal_dibuat timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


--
-- Name: keranjang_id_keranjang_seq; Type: SEQUENCE; Schema: public; Owner: -
--

ALTER TABLE public.keranjang ALTER COLUMN id_keranjang ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.keranjang_id_keranjang_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: pembayaran; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.pembayaran (
    id_pembayaran integer NOT NULL,
    id_pesanan integer NOT NULL,
    metode_pembayaran character varying(50) NOT NULL,
    status_pembayaran character varying(30) DEFAULT 'menunggu'::character varying NOT NULL,
    tanggal_pembayaran timestamp without time zone,
    CONSTRAINT pembayaran_status_pembayaran_check CHECK (((status_pembayaran)::text = ANY ((ARRAY['menunggu'::character varying, 'berhasil'::character varying, 'gagal'::character varying])::text[])))
);


--
-- Name: pembayaran_id_pembayaran_seq; Type: SEQUENCE; Schema: public; Owner: -
--

ALTER TABLE public.pembayaran ALTER COLUMN id_pembayaran ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.pembayaran_id_pembayaran_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: pengiriman; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.pengiriman (
    id_pengiriman integer NOT NULL,
    id_pesanan integer NOT NULL,
    jenis_pengiriman character varying(30) NOT NULL,
    alamat_tujuan text NOT NULL,
    nama_kurir character varying(100),
    nomor_resi character varying(100),
    status_pengiriman character varying(30) DEFAULT 'menunggu'::character varying NOT NULL,
    CONSTRAINT pengiriman_jenis_pengiriman_check CHECK (((jenis_pengiriman)::text = ANY ((ARRAY['kurir_desa'::character varying, 'ekspedisi'::character varying])::text[]))),
    CONSTRAINT pengiriman_status_pengiriman_check CHECK (((status_pengiriman)::text = ANY ((ARRAY['menunggu'::character varying, 'diproses'::character varying, 'dikirim'::character varying, 'diterima'::character varying])::text[])))
);


--
-- Name: pengiriman_id_pengiriman_seq; Type: SEQUENCE; Schema: public; Owner: -
--

ALTER TABLE public.pengiriman ALTER COLUMN id_pengiriman ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.pengiriman_id_pengiriman_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: pesanan; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.pesanan (
    id_pesanan integer NOT NULL,
    id_user integer NOT NULL,
    tanggal_pesanan timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    total_harga numeric(12,2) DEFAULT 0 NOT NULL,
    status_pesanan character varying(30) DEFAULT 'menunggu_pembayaran'::character varying NOT NULL,
    CONSTRAINT pesanan_status_pesanan_check CHECK (((status_pesanan)::text = ANY ((ARRAY['menunggu_pembayaran'::character varying, 'diproses'::character varying, 'dikirim'::character varying, 'selesai'::character varying, 'dibatalkan'::character varying])::text[]))),
    CONSTRAINT pesanan_total_harga_check CHECK ((total_harga >= (0)::numeric))
);


--
-- Name: pesanan_id_pesanan_seq; Type: SEQUENCE; Schema: public; Owner: -
--

ALTER TABLE public.pesanan ALTER COLUMN id_pesanan ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.pesanan_id_pesanan_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: produk; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.produk (
    id_produk integer NOT NULL,
    id_umkm integer NOT NULL,
    id_kategori integer,
    nama_produk character varying(150) NOT NULL,
    deskripsi text,
    harga numeric(12,2) NOT NULL,
    stok integer DEFAULT 0 NOT NULL,
    foto_url text,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    CONSTRAINT produk_harga_check CHECK ((harga >= (0)::numeric)),
    CONSTRAINT produk_stok_check CHECK ((stok >= 0))
);


--
-- Name: produk_id_produk_seq; Type: SEQUENCE; Schema: public; Owner: -
--

ALTER TABLE public.produk ALTER COLUMN id_produk ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.produk_id_produk_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: riwayat_status_pesanan; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.riwayat_status_pesanan (
    id_riwayat integer NOT NULL,
    id_pesanan integer NOT NULL,
    status character varying(30) NOT NULL,
    waktu timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    keterangan text
);


--
-- Name: riwayat_status_pesanan_id_riwayat_seq; Type: SEQUENCE; Schema: public; Owner: -
--

ALTER TABLE public.riwayat_status_pesanan ALTER COLUMN id_riwayat ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.riwayat_status_pesanan_id_riwayat_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: umkm; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.umkm (
    id_umkm integer NOT NULL,
    id_user integer NOT NULL,
    nama_usaha character varying(150) NOT NULL,
    deskripsi text,
    alamat text NOT NULL,
    no_whatsapp character varying(20),
    latitude numeric(10,7),
    longitude numeric(10,7)
);


--
-- Name: umkm_id_umkm_seq; Type: SEQUENCE; Schema: public; Owner: -
--

ALTER TABLE public.umkm ALTER COLUMN id_umkm ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.umkm_id_umkm_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: users; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.users (
    id_user integer NOT NULL,
    nama character varying(100) NOT NULL,
    email character varying(150) NOT NULL,
    password text NOT NULL,
    role character varying(20) NOT NULL,
    no_hp character varying(20),
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    CONSTRAINT users_role_check CHECK (((role)::text = ANY ((ARRAY['admin'::character varying, 'pemilik_umkm'::character varying, 'pembeli'::character varying])::text[])))
);


--
-- Name: users_id_user_seq; Type: SEQUENCE; Schema: public; Owner: -
--

ALTER TABLE public.users ALTER COLUMN id_user ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.users_id_user_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: detail_keranjang detail_keranjang_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.detail_keranjang
    ADD CONSTRAINT detail_keranjang_pkey PRIMARY KEY (id_detail_keranjang);


--
-- Name: detail_pesanan detail_pesanan_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.detail_pesanan
    ADD CONSTRAINT detail_pesanan_pkey PRIMARY KEY (id_detail_pesanan);


--
-- Name: kategori kategori_nama_kategori_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.kategori
    ADD CONSTRAINT kategori_nama_kategori_key UNIQUE (nama_kategori);


--
-- Name: kategori kategori_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.kategori
    ADD CONSTRAINT kategori_pkey PRIMARY KEY (id_kategori);


--
-- Name: keranjang keranjang_id_user_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.keranjang
    ADD CONSTRAINT keranjang_id_user_key UNIQUE (id_user);


--
-- Name: keranjang keranjang_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.keranjang
    ADD CONSTRAINT keranjang_pkey PRIMARY KEY (id_keranjang);


--
-- Name: pembayaran pembayaran_id_pesanan_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.pembayaran
    ADD CONSTRAINT pembayaran_id_pesanan_key UNIQUE (id_pesanan);


--
-- Name: pembayaran pembayaran_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.pembayaran
    ADD CONSTRAINT pembayaran_pkey PRIMARY KEY (id_pembayaran);


--
-- Name: pengiriman pengiriman_id_pesanan_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.pengiriman
    ADD CONSTRAINT pengiriman_id_pesanan_key UNIQUE (id_pesanan);


--
-- Name: pengiriman pengiriman_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.pengiriman
    ADD CONSTRAINT pengiriman_pkey PRIMARY KEY (id_pengiriman);


--
-- Name: pesanan pesanan_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.pesanan
    ADD CONSTRAINT pesanan_pkey PRIMARY KEY (id_pesanan);


--
-- Name: produk produk_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.produk
    ADD CONSTRAINT produk_pkey PRIMARY KEY (id_produk);


--
-- Name: riwayat_status_pesanan riwayat_status_pesanan_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.riwayat_status_pesanan
    ADD CONSTRAINT riwayat_status_pesanan_pkey PRIMARY KEY (id_riwayat);


--
-- Name: umkm umkm_id_user_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.umkm
    ADD CONSTRAINT umkm_id_user_key UNIQUE (id_user);


--
-- Name: umkm umkm_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.umkm
    ADD CONSTRAINT umkm_pkey PRIMARY KEY (id_umkm);


--
-- Name: detail_keranjang uq_keranjang_produk; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.detail_keranjang
    ADD CONSTRAINT uq_keranjang_produk UNIQUE (id_keranjang, id_produk);


--
-- Name: users users_email_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_email_key UNIQUE (email);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id_user);


--
-- Name: detail_keranjang fk_detail_keranjang; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.detail_keranjang
    ADD CONSTRAINT fk_detail_keranjang FOREIGN KEY (id_keranjang) REFERENCES public.keranjang(id_keranjang) ON DELETE CASCADE;


--
-- Name: detail_pesanan fk_detail_pesanan; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.detail_pesanan
    ADD CONSTRAINT fk_detail_pesanan FOREIGN KEY (id_pesanan) REFERENCES public.pesanan(id_pesanan) ON DELETE CASCADE;


--
-- Name: detail_pesanan fk_detail_pesanan_produk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.detail_pesanan
    ADD CONSTRAINT fk_detail_pesanan_produk FOREIGN KEY (id_produk) REFERENCES public.produk(id_produk) ON DELETE RESTRICT;


--
-- Name: detail_keranjang fk_detail_produk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.detail_keranjang
    ADD CONSTRAINT fk_detail_produk FOREIGN KEY (id_produk) REFERENCES public.produk(id_produk) ON DELETE RESTRICT;


--
-- Name: keranjang fk_keranjang_user; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.keranjang
    ADD CONSTRAINT fk_keranjang_user FOREIGN KEY (id_user) REFERENCES public.users(id_user) ON DELETE CASCADE;


--
-- Name: pembayaran fk_pembayaran_pesanan; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.pembayaran
    ADD CONSTRAINT fk_pembayaran_pesanan FOREIGN KEY (id_pesanan) REFERENCES public.pesanan(id_pesanan) ON DELETE RESTRICT;


--
-- Name: pengiriman fk_pengiriman_pesanan; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.pengiriman
    ADD CONSTRAINT fk_pengiriman_pesanan FOREIGN KEY (id_pesanan) REFERENCES public.pesanan(id_pesanan) ON DELETE RESTRICT;


--
-- Name: pesanan fk_pesanan_user; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.pesanan
    ADD CONSTRAINT fk_pesanan_user FOREIGN KEY (id_user) REFERENCES public.users(id_user) ON DELETE RESTRICT;


--
-- Name: produk fk_produk_kategori; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.produk
    ADD CONSTRAINT fk_produk_kategori FOREIGN KEY (id_kategori) REFERENCES public.kategori(id_kategori) ON DELETE SET NULL;


--
-- Name: produk fk_produk_umkm; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.produk
    ADD CONSTRAINT fk_produk_umkm FOREIGN KEY (id_umkm) REFERENCES public.umkm(id_umkm) ON DELETE RESTRICT;


--
-- Name: riwayat_status_pesanan fk_riwayat_pesanan; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.riwayat_status_pesanan
    ADD CONSTRAINT fk_riwayat_pesanan FOREIGN KEY (id_pesanan) REFERENCES public.pesanan(id_pesanan) ON DELETE CASCADE;


--
-- Name: umkm fk_umkm_user; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.umkm
    ADD CONSTRAINT fk_umkm_user FOREIGN KEY (id_user) REFERENCES public.users(id_user) ON DELETE RESTRICT;


--
-- PostgreSQL database dump complete
--

\unrestrict qiKxrK7VlzLzeq9KBjN1LhjIyNp4bWVHZ88bgsEar3lO4bRhNFbw9cudPdPn5UZ

