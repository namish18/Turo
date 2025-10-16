const resourceSchema = new mongoose.Schema({
  courseId: {
    type: mongoose.Schema.Types.ObjectId,
    ref: 'Course',
    required: true
  },
  teacher: {
    type: mongoose.Schema.Types.ObjectId,
    ref: 'User',
    required: true
  },
  title: {
    type: String,
    required: true,
    trim: true
  },
  description: String,
  resourceType: {
    type: String,
    enum: ['pdf', 'document', 'notes', 'link'],
    required: true
  },
  fileUrl: {
    type: String,
    required: true
  },
  isDownloadable: {
    type: Boolean,
    default: true
  },
  tags: [String],
  createdAt: {
    type: Date,
    default: Date.now
  }
}, { timestamps: true });

module.exports = mongoose.model('Resource', resourceSchema);
