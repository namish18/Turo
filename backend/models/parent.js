const parentSchema = new mongoose.Schema({
  name: {
    type: String,
    required: true,
    trim: true
  },
  contactNumber: {
    type: String,
    required: true,
    match: /^[0-9]{10}$/
  },
  email: {
    type: String,
    lowercase: true,
    match: /^[^\s@]+@[^\s@]+\.[^\s@]+$/
  },
  student: {
    type: mongoose.Schema.Types.ObjectId,
    ref: 'User',
    required: true
  },
  teacher: {
    type: mongoose.Schema.Types.ObjectId,
    ref: 'User',
    required: true
  },
  relationshipType: {
    type: String,
    enum: ['father', 'mother', 'guardian'],
    default: 'guardian'
  },
  createdAt: {
    type: Date,
    default: Date.now
  }
}, { timestamps: true });

module.exports = mongoose.model('Parent', parentSchema);
