require 'rails_helper'

RSpec.describe OclcBook, :type => :model do
  it "allows the descriptions attribute to be trated as array" do
    book = build(:oclc_book)

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

  it "allows the titles attribute to be treated as array" do
    book = build(:oclc_book)
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
end
