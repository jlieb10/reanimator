class DescriptionsStrategy < QuestionConstructor::Strategy::Base
  
  define_reference :subject do |user, question|
    pool do
      GutenbergBook.simple_join(:equivalencies, :on => :book_nid)
                   .sharing_works(
                    having_books_that_are_not_missing: [ "description", :only => "oclc_books" ],
                    having_unrenferenced_books: 
                      {
                        user: user,
                        question: question,
                        role: "reference",
                        only: "oclc_books"
                      })
    end
  end

  define_reference do |user, question|
    column :description
    pool do
      OclcBook.unreferenced(:user => user, :question => question, :role => :reference)
              .in_same_work_as(subject)
              .not_missing(:description)
    end
  end

end
