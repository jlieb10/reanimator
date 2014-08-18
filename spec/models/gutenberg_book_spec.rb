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
    describe "#missing" do

      describe "when book is missing given attribute" do

        it "returns a book that book if attribute is nil" do
          book = create(:gutenberg_book, :subtitle => nil)
          expect(GutenbergBook.missing(:subtitle)).to include(book)
        end

        it "returns that book if attribute is serialized and doesnt have any values" do
          book = create(:gutenberg_book, :titles => [])
          expect(GutenbergBook.missing(:titles)).to include(book)
        end

      end

      describe "when book is not missing attribute" do
        it "does not return a book when the attribute is not nil and not a serialized empty value" do
          book = create(:gutenberg_book, :subtitle => "a lovely book")
          expect(GutenbergBook.missing(:subtitle)).not_to include(book)
        end

        it "does not return a book when attribute is a filled serialzed value" do
          book = create(:gutenberg_book, :titles => ["a lovely book"])
          expect(GutenbergBook.missing(:titles)).not_to include(book)
        end
      end
    end

    describe "#not_missing" do
      describe "when book is missing given attribute" do

        it "returns a book that book if attribute is nil" do
          book = create(:gutenberg_book, :subtitle => nil)
          expect(GutenbergBook.not_missing(:subtitle)).not_to include(book)
        end

        it "returns that book if attribute is serialized and doesnt have any values" do
          book = create(:gutenberg_book, :titles => [])
          expect(GutenbergBook.not_missing(:titles)).not_to include(book)
        end

      end

      describe "when book is not missing attribute" do
        it "does not return a book when the attribute is not nil and not a serialized empty value" do
          book = create(:gutenberg_book, :subtitle => "a lovely book")
          expect(GutenbergBook.not_missing(:subtitle)).to include(book)
        end

        it "does not return a book when attribute is a filled serialzed value" do
          book = create(:gutenberg_book, :titles => ["a lovely book"])
          expect(GutenbergBook.not_missing(:titles)).to include(book)
        end
      end
    end

    describe "#referenced" do
      it "returns only referenced books" do
        referenced_book = create(:gutenberg_book, :titles => ['first'])

        george = build_stubbed(:user)
        question = build_stubbed(:question)
        option = build_stubbed(:option)
        option.questions << question

        submission = george.submissions.create(:question => question, option: option)
        submission.references.create(referenced: referenced_book)

        referenced_books = GutenbergBook.referenced(:user => george, :question => question)
        expect(referenced_books).to include(referenced_book)
      end

      it "does not return an unreferenced book" do
        unreferenced_book = create(:gutenberg_book, :titles => ['first'])

        george = build_stubbed(:user)
        question = build_stubbed(:question)

        referenced_books = GutenbergBook.referenced(:user => george, :question => question)
        expect(referenced_books).not_to include(unreferenced_book)
      end

      it "returns books referenced specifically by a user" do
        george_references_this = create(:gutenberg_book, :titles => ["george"])
        steven_references_this = create(:gutenberg_book, :titles => ["steven"])

        george = build_stubbed(:user, :name => "George")
        steven = build_stubbed(:user, :name => "Steven")

        question = build_stubbed(:question)
        option = build_stubbed(:option)
        option.questions << question

        georges_submission = george.submissions.create(:question => question, :option => option)
        georges_submission.references.create(referenced: george_references_this)

        steven_submission = steven.submissions.create(:question => question, :option => option)
        steven_submission.references.create(referenced: steven_references_this)

        steven_referenced_these = GutenbergBook.referenced(:user => steven, :question => question)
        george_referenced_these = GutenbergBook.referenced(:user => george, :question => question)

        expect(steven_referenced_these).to     include(steven_references_this)
        expect(steven_referenced_these).not_to include(george_references_this)
        expect(george_referenced_these).to     include(george_references_this)
        expect(george_referenced_these).not_to include(steven_references_this)
      end

      it "returns books referenced specifically by in a question" do
        first_reference = create(:gutenberg_book, :titles => ["first"])
        second_reference = create(:gutenberg_book, :titles => ["second"])

        george = build_stubbed(:user, :name => "George")

        first_question = build_stubbed(:question, :content => "first?")
        second_question = build_stubbed(:question, :content => "second?")

        option = build_stubbed(:option)
        option.questions << [first_question, second_question]

        georges_first_submission = george.submissions.create(:question => first_question, :option => option)
        georges_first_submission.references.create(referenced: first_reference)

        georges_second_submission = george.submissions.create(:question => second_question, :option => option)
        georges_second_submission.references.create(referenced: second_reference)

        first_referenced = GutenbergBook.referenced(:user => george, :question => first_question)
        second_referenced = GutenbergBook.referenced(:user => george, :question => second_question)

        expect(first_referenced).to     include(first_reference)
        expect(first_referenced).not_to include(second_reference)
        expect(second_referenced).to    include(second_reference)
        expect(second_referenced).not_to include(first_reference)
      end
    end

    describe "#unreferenced" do

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

      it "returns unreferenced books by a specific user and question" do
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
        expect(second_set_books.sort).to eq([first_book, second_book].sort)
        expect(third_set_books.sort).to eq([first_book, second_book].sort)
        expect(fourth_set_books).to eq([first_book])

      end
    end

    describe "#having_works" do
      it "returns books that are a part of an oclc_work" do
        work = create(:oclc_work)
        book_in_work = create(:gutenberg_book)
        book_no_work = create(:oclc_book)

        equiv = create(:equivalency, :book => book_in_work, :oclc_work => nil)
        work.equivalencies << equiv
        
        books_in_work = GutenbergBook.having_works

        expect(books_in_work).to include(book_in_work)
        expect(books_in_work).not_to include(book_no_work)
      end
    end

    describe "#sharing_works" do
      it "returns books that share a work with other books" do
        work = create(:oclc_work)
        book_in_work = create(:gutenberg_book)
        another_book_in_work = create(:oclc_book)

        first_equiv = create(:equivalency, :book => book_in_work, :oclc_work => nil)
        work.equivalencies << first_equiv

        second_equiv = create(:equivalency, :book => another_book_in_work, :oclc_work => nil)
        work.equivalencies << second_equiv
        
        books_sharing_works = GutenbergBook.sharing_works

        expect(books_sharing_works).to include(book_in_work)
      end

      it "does not return books that have works but are not shared with other books" do
        first_work = create(:oclc_work)
        second_work = create(:oclc_work)

        book_in_work = create(:gutenberg_book)
        another_book_in_work = create(:oclc_book)

        first_equiv = create(:equivalency, :book => book_in_work, :oclc_work => nil)
        first_work.equivalencies << first_equiv

        second_equiv = create(:equivalency, :book => another_book_in_work, :oclc_work => nil)
        second_work.equivalencies << second_equiv
        
        books_sharing_works = GutenbergBook.sharing_works

        expect(books_sharing_works).to be_empty
      end
    end

    describe "#in_same_work_as" do
      it "returns books that are part of the same work as the argument" do
        work = create(:oclc_work)
        book_in_work = create(:gutenberg_book)
        book_not_in_work = create(:gutenberg_book)
        another_book_in_work = create(:gutenberg_book)

        first_equiv = create(:equivalency, :book => book_in_work, :oclc_work => nil)
        work.equivalencies << first_equiv

        second_equiv = create(:equivalency, :book => another_book_in_work, :oclc_work => nil)
        work.equivalencies << second_equiv
        
        books_in_work = GutenbergBook.in_same_work_as(book_in_work)

        expect(books_in_work).to include(another_book_in_work)
        expect(books_in_work).not_to include(book_not_in_work)
      end
    end

    describe "#having_different" do
      it "returns records which have values differing from the given attribute on the given object" do
        first = create(:gutenberg_book, :titles => ["first"])
        second = create(:gutenberg_book, :titles => ["second"])
        third = create(:gutenberg_book, :titles => ["first"])

        books = GutenbergBook.having_different(:titles, :as => second)
        expect(books).to include(first, third)
        expect(books).not_to include(second)
      end
    end
  end
end
