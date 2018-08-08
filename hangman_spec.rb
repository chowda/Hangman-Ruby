require 'rspec'
require './hangman.rb'
require './hangman_solver.rb'

describe "HangmanSolver" do
  context "solves the puzzle" do
    let(:hangman) { Hangman.new("alphabet") }
    let(:solver)  { HangmanSolver.new(hangman) }

    before do
      solver.solve
    end

    it "solves within 26 guesses" do
      expect(solver.guesses.size).to be <= 26
    end

    it "doesn't guess the same letter twice" do
      expect(solver.guesses.size).to eq(solver.guesses.uniq.size)
    end
  end

  context "handles capital letters" do
    let(:hangman) { Hangman.new("AlPhAbEt") }
    let(:solver)  { HangmanSolver.new(hangman) }

    before do
      solver.solve
    end

    it "solves within 26 guesses" do
      expect(solver.guesses.size).to be <= 26
    end
  end

  context "solves a word not found in the corpus" do
    let(:hangman) { Hangman.new("constitutionalised") }
    let(:solver)  { HangmanSolver.new(hangman) }

    before do
      solver.solve
    end

    it "solves within 26 guesses" do
      expect(solver.guesses.size).to be <= 26
    end
  end
end
