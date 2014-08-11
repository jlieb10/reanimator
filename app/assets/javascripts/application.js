// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/sstephenson/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require foundation
//= require turbolinks
//= require_tree .

$(document).on( 'page:change', function() {
  var authors = ['Shakespeare', 'Tolstoy', 'Austen', 'Dickens', 'Woolf', 'Faulkner', 'Dickinson', 'Dostoyevsky', 'Tolkien', 'Joyce', 'Cervantes', 'Hemingway', 'Poe', 'Nabakov', 'Orwell', 'Christie', 'Márquez', 'Angelou', 'Morrison', 'Shelley', 'Dante', 'Beckett', 'Borges', 'Brontë', 'Chaucer', 'Conrad', 'Eliot', 'Kafka', 'Melville', 'Swift', 'Twain', 'Whitman']

  function randomAuthor() {
    indx = Math.floor(Math.random() * (authors.length - 1));
    return authors[indx];
  };

  function updateAuthor() {
    var auth = $('#authors1, #authors2');
    var width = $('h1.')

    if(auth.is(':visible')) {
      auth.fadeOut(500, function(){
        $(this).text(randomAuthor());
        $(this).parent('h1').animate({width, 1000);
      });
    } else {
      auth.fadeIn(500);
    };

    // if(auth2.is(':visible')) {
    //   auth2.fadeOut(500, function(){
    //     auth2.text(randomAuthor()+"?");
    //   });
    // } else {
    //   auth2.fadeIn(500);
    // };
  };

  updateAuthor();

  setInterval(function(){updateAuthor()}, 500);

  $(document).foundation();
  });
});
