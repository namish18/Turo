const questionSchema = new mongoose.Schema({
  questionId: {
    type: String,
    required: true
  },
  questionText: {
    type: String,
    required: true
  },
  options: [{
    optionText: String,
    isCorrect: Boolean
  }],
  correctAnswer: {
    type: String,
    required: true
  },
  points: {
    type: Number,
    default: 1
  },
  topic: String // For identifying topic gaps
});

const quizSchema = new mongoose.Schema({
  quizId: {
    type: String,
    required: true,
    unique: true
  },
  courseId: {
    type: mongoose.Schema.Types.ObjectId,
    ref: 'Course',
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
  teacher: {
    type: mongoose.Schema.Types.ObjectId,
    ref: 'User',
    required: true
  },
  questions: [questionSchema],
  totalPoints: {
    type: Number,
    default: 0
  },
  duration: {
    type: Number, // in minutes
    default: 30
  },
  isActive: {
    type: Boolean,
    default: true
  },
  createdAt: {
    type: Date,
    default: Date.now
  }
}, { timestamps: true });

module.exports = mongoose.model('Quiz', quizSchema);
