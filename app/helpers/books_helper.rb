module BooksHelper
  
  def oclc_book_url(book)
    book.to_url
  end
end