const leaderboardSchema = new mongoose.Schema({
  courseId: {
    type: mongoose.Schema.Types.ObjectId,
    ref: 'Course',
    required: true
  },
  quizId: {
    type: mongoose.Schema.Types.ObjectId,
    ref: 'Quiz'
  },
  rankings: [{
    student: {
      type: mongoose.Schema.Types.ObjectId,
      ref: 'User'
    },
    username: String,
    totalScore: {
      type: Number,
      default: 0
    },
    averageScore: {
      type: Number,
      default: 0
    },
    attemptCount: {
      type: Number,
      default: 0
    },
    bestScore: {
      type: Number,
      default: 0
    },
    rank: Number,
    lastUpdated: {
      type: Date,
      default: Date.now
    }
  }],
  lastUpdated: {
    type: Date,
    default: Date.now
  }
}, { timestamps: true });

// Index for efficient ranking queries
leaderboardSchema.index({ courseId: 1, 'rankings.totalScore': -1 });

module.exports = mongoose.model('Leaderboard', leaderboardSchema);
