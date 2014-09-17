##Readme

To create a new question or set of questions (as "task") navigate to app/db/data/tasks.yaml

The attributes of a task are:<br>
  * name<br>
  * category<br>
  * question(s)<br>
	  * expectations (type of input like "radio")<br>
	  * content (the question being asked)<br>
	  * options<br>
        * values<br>
        * additional_input (no_input, image, short_text, long_text -- see or modify in question_options.rb)<br>

example:<br>
```yaml
tasks:
-
  name: Compare Titles
  category: Titles
  questions:
  -
    expectation: radio
    content: Do these titles refer to the same book?
    options:
      -
        value: "Yes"
      -
        value: "No"
      -
        additional_input: no_input # optional
```

Then create a strategy to generate a reference in app/question_strategies/

You may use the scopes available in the models or add your own.
You need to define the column being referred to and the pool to search from

example:<br>
```ruby
class CompareTitlesStrategy < QuestionConstructor::Strategy
  
  define_reference :subject do |user, question| 
    column :title
    pool do
      GutenbergBook.simple_join(:equivalencies, :on => :book_nid)
                   .sharing_works_with_unreferenced_books(:user => user, :question => question, :role => :reference)
                   .with_inconsistent_titles
    end
  end

  define_reference :reference do |user, question|
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
```

Make your strategy name reflect the name attribute of the task. If your task is named "Compare Titles," your strategy's class should be "CompareTitlesStrategy." QuestionConstructor (in lib folder) will call Question#suggested_strategy which will try to match the task and strategy using the above approach. Alternatively, the question constructor can take a third argument on initialization, which would be the name of the strategy.





