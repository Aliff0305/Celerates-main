
const pool = require('../config/db');
const bcrypt = require('bcrypt');

const BASE_SELECT = `
  SELECT id_user, nama, email, role, no_hp, created_at
  FROM users
`;

const getAll = async (id_user, role) => {
  const params = [];
  const conditions = [];

  if (id_user) {
    params.push(id_user);
    conditions.push(`id_user = $${params.length}`);
  }

  if (role) {
    params.push(role);
    conditions.push(`role = $${params.length}`);
  }

  const where = conditions.length
    ? `WHERE ${conditions.join(' AND ')}`
    : '';

  const result = await pool.query(
    `${BASE_SELECT} ${where} ORDER BY created_at DESC`,
    params
  );

  return result.rows;
};

const create = async ({ nama, email, password, role, no_hp }) => {
  const hashedPassword = await bcrypt.hash(password, 10);

  try {
    const result = await pool.query(
      `INSERT INTO users (nama, email, password, role, no_hp)
       VALUES ($1, $2, $3, $4, $5)
       RETURNING id_user, nama, email, role, no_hp, created_at`,
      [nama, email, hashedPassword, role, no_hp || null]
    );

    return result.rows[0];
  } catch (err) {
    if (err.code === '23505') {
      return { error: 'EMAIL_EXISTS' };
    }
    throw err;
  }
};

const update = async (id_user, { nama, email, password, role, no_hp }) => {
  const fields = [];
  const params = [];

  if (nama !== undefined) {
    params.push(nama);
    fields.push(`nama = $${params.length}`);
  }

  if (email !== undefined) {
    params.push(email);
    fields.push(`email = $${params.length}`);
  }

  if (password !== undefined) {
    const hashedPassword = await bcrypt.hash(password, 10);
    params.push(hashedPassword);
    fields.push(`password = $${params.length}`);
  }

  if (role !== undefined) {
    params.push(role);
    fields.push(`role = $${params.length}`);
  }

  if (no_hp !== undefined) {
    params.push(no_hp);
    fields.push(`no_hp = $${params.length}`);
  }

  if (fields.length === 0) {
    const existing = await pool.query(
      `${BASE_SELECT} WHERE id_user = $1`,
      [id_user]
    );
    return existing.rows[0] || null;
  }

  params.push(id_user);

  try {
    const result = await pool.query(
      `UPDATE users
       SET ${fields.join(', ')}
       WHERE id_user = $${params.length}
       RETURNING id_user, nama, email, role, no_hp, created_at`,
      params
    );

    return result.rows[0] || null;
  } catch (err) {
    if (err.code === '23505') {
      return { error: 'EMAIL_EXISTS' };
    }
    throw err;
  }
};

const remove = async (id_user) => {
  const result = await pool.query(
    `DELETE FROM users
     WHERE id_user = $1
     RETURNING id_user, nama, email, role, no_hp, created_at`,
    [id_user]
  );

  return result.rows[0];
};

module.exports = { getAll, create, update, remove };
