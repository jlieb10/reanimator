require 'rails_helper'

RSpec.describe Book, :type => :model do
  describe "Serializations" do
    it "allows the titles attribute to be treated as array" do
      book = build(:book)
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
      book = build(:book)
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

    it "allows the descriptions attribute to be trated as array" do
      book = build(:book)

      expect(book.descriptions).to be_an_instance_of(Array)

      book.descriptions << Faker::Lorem.sentence(10)
      book.descriptions << Faker::Lorem.sentence(10)

      expect(book.descriptions.size).to eq(2)
      expect{ book.save }.to_not raise_error
      # it should still be an instance of Array after retrieving back from db
      book.reload
      expect(book.descriptions).to be_an_instance_of(Array)
      expect(book.descriptions.size).to eq(2)
    end

    it "allows the links attribute to be treated as a hash" do
      book = build(:book)
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
end
