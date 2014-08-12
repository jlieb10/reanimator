require 'rails_helper'

RSpec.describe GutenbergBook, :type => :model do
  describe "Serializations" do
    it "allows the titles attribute to be treated as array" do
      book = build(:gutenberg_book)
      expect(book.titles).to be_an_instance_of(Array)
      
      book.titles << "The works"
      book.titles << "Shakespear's works"

      expect(book.titles.size).to eq(2)
      expect{ book.save }.to_not raise_error
      # it should still be an instance of Array after retrieving back from db
      book.reload
      expect(book.titles).to be_an_instance_of(Array)
      expect(book.titles.size).to eq(2)
    end

    it "allows the authors attribute to be trated as array" do
      book = build(:gutenberg_book)
      expect(book.authors).to be_an_instance_of(Array)

      book.authors << "Shakespear"
      book.authors << "Tolstoy"

      expect(book.authors.size).to eq(2)
      expect{ book.save }.to_not raise_error
      # it should still be an instance of Array after retrieving back from db
      book.reload
      expect(book.authors).to be_an_instance_of(Array)
      expect(book.authors.size).to eq(2)
    end


    it "allows the links attribute to be treated as a hash" do
      book = build(:gutenberg_book)
      expect(book.links).to be_an_instance_of(Hash)

      book.links[:home] = Faker::Internet.url
      book.links[:epub] = Faker::Internet.url

      expect(book.links.keys).to include(:home)
      expect(book.links.keys).to include(:epub)

      expect{ book.save }.to_not raise_error

      book.reload
      expect(book.links).to be_an_instance_of(Hash)
      expect(book.links.keys).to include(:home)
      expect(book.links.keys).to include(:epub)
    end
  end

  describe "scopes" do
    it "returns only unreferenced books" do
      unreferenced_book = create(:filled_gutenberg_book, titles: ['unreferenced'] )
      
      george = create(:user)
      question = create(:question)

      books = GutenbergBook.unreferenced(user: george, question: question)

      expect(books).to include(unreferenced_book)
    end

    it "returns an empty result set if no books unreferenced" do
      referenced_book = create(:filled_gutenberg_book, titles: ['referenced'])
      
      george = create(:user)
      question = create(:question)
      option = create(:option)
      submission = create(:submission, user: george, question: question, option: option)
      submission.references.create referenced: referenced_book

      books = GutenbergBook.unreferenced(user: george, question: question)

      expect(books).not_to include(referenced_book)
    end

    it "returns referenced books by a specific user and question" do
      first_book = create(:filled_gutenberg_book, titles: ['first'])
      second_book = create(:filled_gutenberg_book, titles: ['second'])
      
      george = create(:user, :name => "George")
      steven = create(:user, :name => "Steven")

      first_question = create(:question, :content => "first")
      second_question = create(:question, :content => "second")

      option = create(:option)

      first_submission = create(:submission, user: george, question: first_question, option: option)
      second_submission = create(:submission, user: steven, question: second_question, option: option)

      first_submission.references.create referenced: first_book
      second_submission.references.create referenced: second_book

      first_set_books = GutenbergBook.unreferenced(user: george, question: first_question)
      second_set_books = GutenbergBook.unreferenced(user: george, question: second_question)
      third_set_books = GutenbergBook.unreferenced(user: steven, question: first_question)
      fourth_set_books = GutenbergBook.unreferenced(user: steven, question: second_question)

      expect(first_set_books).to eq([second_book])
      expect(second_set_books).to eq([first_book, second_book])
      expect(third_set_books).to eq([first_book, second_book])
      expect(fourth_set_books).to eq([first_book])

    end
  end
end
