
const userService = require('../services/userService');

const VALID_ROLE = ['admin', 'pemilik_umkm', 'pembeli'];

const sendError = (res, code, message) =>
  res.status(code).json({ success: false, message });

const isValidId = (id) => /^\d+$/.test(String(id));

const getUsers = async (req, res) => {
  try {
    const { id_user, role } = req.query;
    const data = await userService.getAll(id_user, role);

    if ((id_user || role) && data.length === 0) {
      return sendError(res, 404, 'Data user tidak ditemukan');
    }

    res.status(200).json({
      success: true,
      message: 'Data user berhasil diambil',
      data,
    });
  } catch (err) {
    console.error(err);
    sendError(res, 500, 'Terjadi kesalahan pada server');
  }
};

const getUserById = async (req, res) => {
  try {
    const { id_user } = req.params;

    if (!isValidId(id_user)) {
      return sendError(res, 400, 'ID user tidak valid');
    }

    const [data] = await userService.getAll(id_user);

    if (!data) {
      return sendError(res, 404, 'User tidak ditemukan');
    }

    res.status(200).json({
      success: true,
      message: 'Data user berhasil diambil',
      data,
    });
  } catch (err) {
    console.error(err);
    sendError(res, 500, 'Terjadi kesalahan pada server');
  }
};

const updateUser = async (req, res) => {
  try {
    const { id_user } = req.params;
    const { nama, email, password, role, no_hp } = req.body;

    if (!isValidId(id_user)) {
      return sendError(res, 400, 'ID user tidak valid');
    }

    if (role && !VALID_ROLE.includes(role)) {
      return sendError(
        res,
        400,
        `Role harus salah satu dari: ${VALID_ROLE.join(', ')}`
      );
    }

    if (email && !email.trim()) {
      return sendError(res, 400, 'Email tidak boleh kosong');
    }

    if (nama !== undefined && !nama.trim()) {
      return sendError(res, 400, 'Nama tidak boleh kosong');
    }

    const result = await userService.update(id_user, req.body);

    if (!result) {
      return sendError(res, 404, 'User tidak ditemukan');
    }

    if (result.error === 'EMAIL_EXISTS') {
      return sendError(res, 409, 'Email sudah digunakan user lain');
    }

    res.status(200).json({
      success: true,
      message: 'Data user berhasil diperbarui',
      data: result,
    });
  } catch (err) {
    console.error(err);
    sendError(res, 500, 'Terjadi kesalahan pada server');
  }
};

const deleteUser = async (req, res) => {
  try {
    const { id_user } = req.params;

    if (!isValidId(id_user)) {
      return sendError(res, 400, 'ID user tidak valid');
    }

    const data = await userService.remove(id_user);

    if (!data) {
      return sendError(res, 404, 'User tidak ditemukan');
    }

    res.status(200).json({
      success: true,
      message: 'User berhasil dihapus',
      data,
    });
  } catch (err) {
    console.error(err);
    sendError(res, 500, 'Terjadi kesalahan pada server');
  }
};

module.exports = { getUsers, getUserById, updateUser, deleteUser };
