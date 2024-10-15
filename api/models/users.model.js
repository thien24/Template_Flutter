const mongoose = require('mongoose');

// Tạo schema cho người dùng
const userSchema = new mongoose.Schema({
  firstName: {
    type: String,
    required: true,
  },
  lastName: {
    type: String,
    required: true,
  },
  country: {
    type: String,
    required: true,
  },
  email: {
    type: String,
    required: true,
    unique: true, // Đảm bảo email là duy nhất
  },
  password: {
    type: String,
    required: true,
  },
  role: {
    type: String,
    enum: ['Traveler', 'Guide'], // Giới hạn giá trị của role
    default: 'Traveler',
  },
}, { timestamps: true });

module.exports = mongoose.model('User', userSchema);
