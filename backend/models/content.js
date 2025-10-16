const contentSchema = new mongoose.Schema({
  contentId: {
    type: String,
    required: true,
    unique: true
  },
  courseId: {
    type: mongoose.Schema.Types.ObjectId,
    ref: 'Course',
    required: true
  },
  contentType: {
    type: String,
    enum: ['video', 'document', 'pdf', 'youtube', 'drive', 'notes'],
    required: true
  },
  title: {
    type: String,
    required: true,
    trim: true
  },
  description: {
    type: String,
    required: true
  },
  // For recorded courses
  contentUrl: {
    type: String,
    validate: {
      validator: function(v) {
        // Validate YouTube or Drive links
        return /^(https?:\/\/)?(www\.)?(youtube\.com|youtu\.be|drive\.google\.com)/.test(v);
      },
      message: 'Please provide a valid YouTube or Google Drive link'
    }
  },
  fileUrl: String, // For PDFs and notes
  order: {
    type: Number,
    default: 0
  },
  duration: Number, // in minutes for videos
  createdAt: {
    type: Date,
    default: Date.now
  }
}, { timestamps: true });

module.exports = mongoose.model('Content', contentSchema);
