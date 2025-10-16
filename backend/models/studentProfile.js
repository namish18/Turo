const studentProfileSchema = new mongoose.Schema({
  student: {
    type: mongoose.Schema.Types.ObjectId,
    ref: 'User',
    required: true,
    unique: true
  },
  quizHistory: [{
    quiz: {
      type: mongoose.Schema.Types.ObjectId,
      ref: 'Quiz'
    },
    attempt: {
      type: mongoose.Schema.Types.ObjectId,
      ref: 'QuizAttempt'
    },
    score: Number,
    date: Date
  }],
  // Heatmap data - similar to GitHub contribution graph
  activityHeatmap: [{
    date: {
      type: Date,
      required: true
    },
    quizzesAttempted: {
      type: Number,
      default: 0
    },
    totalScore: {
      type: Number,
      default: 0
    }
  }],
  // Topic-wise performance analysis
  topicGaps: [{
    topic: String,
    totalAttempts: Number,
    correctAnswers: Number,
    accuracy: Number,
    needsImprovement: {
      type: Boolean,
      default: false
    },
    lastAttempted: Date
  }],
  // Overall statistics
  stats: {
    totalQuizzesAttempted: {
      type: Number,
      default: 0
    },
    averageScore: {
      type: Number,
      default: 0
    },
    totalTimeSpent: {
      type: Number,
      default: 0
    }, // in minutes
    strongTopics: [String],
    weakTopics: [String],
    currentStreak: {
      type: Number,
      default: 0
    },
    longestStreak: {
      type: Number,
      default: 0
    }
  },
  recommendations: [{
    type: {
      type: String,
      enum: ['course', 'topic', 'practice']
    },
    title: String,
    description: String,
    reason: String,
    courseId: {
      type: mongoose.Schema.Types.ObjectId,
      ref: 'Course'
    },
    createdAt: {
      type: Date,
      default: Date.now
    }
  }]
}, { timestamps: true });

// Index for efficient queries
studentProfileSchema.index({ student: 1 });
studentProfileSchema.index({ 'activityHeatmap.date': 1 });

module.exports = mongoose.model('StudentProfile', studentProfileSchema);
