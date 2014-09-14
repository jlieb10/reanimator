class CompareTitlesStrategy < QuestionConstructor::Strategy::Base 
  
  define_reference :subject do |user, question| 
    column :title
    pool do
      GutenbergBook.simple_join(:equivalencies, :on => :book_nid)
                   .sharing_works_with_unreferenced_books(:user => user, :question => question, :role => :reference)
                   .with_inconsistent_titles
    end
  end

  define_reference do |user, question|
    column :title
    pool do
      [GutenbergBook, OclcBook].flat_map do |model|
        model.unreferenced(:user => user, :question => question, :role => :reference)
             .in_same_work_as(subject)
             .having_different(:title, :as => subject)
      end
    end
  end

end