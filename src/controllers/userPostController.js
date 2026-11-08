const userService = require('../services/userService');

const VALID_ROLE = ['admin', 'pemilik_umkm', 'pembeli'];

const sendError = (res, code, message) =>
  res.status(code).json({ success: false, message });

const createUser = async (req, res) => {
  try {
    const { nama, email, password, role } = req.body;

    if (
      !nama?.trim() ||
      !email?.trim() ||
      !password?.trim() ||
      !role?.trim()
    ) {
      return sendError(res, 400, 'Nama, email, password, dan role wajib diisi');
    }

    if (!VALID_ROLE.includes(role)) {
      return sendError(
        res,
        400,
        `Role harus salah satu dari: ${VALID_ROLE.join(', ')}`
      );
    }

    const data = await userService.create(req.body);

    if (data?.error === 'EMAIL_EXISTS') {
      return sendError(res, 409, 'Email sudah terdaftar');
    }

    res.status(201).json({
      success: true,
      message: 'User berhasil ditambahkan',
      data,
    });
  } catch (err) {
    console.error(err);
    sendError(res, 500, 'Terjadi kesalahan pada server');
  }
};

module.exports = createUser;
