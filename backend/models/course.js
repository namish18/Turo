const courseSchema = new mongoose.Schema({
  courseId: {
    type: String,
    required: true,
    unique: true,
    trim: true
  },
  courseName: {
    type: String,
    required: true,
    trim: true
  },
  syllabus: {
    type: String,
    required: true
  },
  courseType: {
    type: String,
    enum: ['group', 'recorded'],
    required: true
  },
  teacher: {
    type: mongoose.Schema.Types.ObjectId,
    ref: 'User',
    required: true
  },
  // For Group Courses
  cohort: {
    learners: [{
      type: mongoose.Schema.Types.ObjectId,
      ref: 'User'
    }],
    sessions: [{
      sessionId: String,
      title: String,
      scheduledDate: Date,
      duration: Number, // in minutes
      meetingLink: String
    }]
  },
  // Course Content
  contents: [{
    type: mongoose.Schema.Types.ObjectId,
    ref: 'Content'
  }],
  enrolledStudents: [{
    studentId: {
      type: mongoose.Schema.Types.ObjectId,
      ref: 'User'
    },
    enrolledDate: {
      type: Date,
      default: Date.now
    },
    progress: {
      type: Number,
      default: 0,
      min: 0,
      max: 100
    }
  }],
  createdAt: {
    type: Date,
    default: Date.now
  }
}, { timestamps: true });

module.exports = mongoose.model('Course', courseSchema);
