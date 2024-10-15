const express = require('express');
const router = express.Router();
const User = require('../models/users.model');

// Đăng ký người dùng
router.post('/signup', async (req, res) => {
  const { firstName, lastName, country, email, password, role } = req.body;

  // Kiểm tra nếu email đã tồn tại
  const existingUser = await User.findOne({ email });
  if (existingUser) {
    return res.status(400).json({ message: 'Email already exists' });
  }

  // Tạo người dùng mới
  const newUser = new User({ firstName, lastName, country, email, password, role });
  try {
    await newUser.save();
    res.status(201).json({ message: 'User registered successfully' });
  } catch (error) {
    res.status(500).json({ message: 'Error registering user', error });
  }
});

module.exports = router;
