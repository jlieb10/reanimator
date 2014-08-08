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
//= require jquery.wordrotator
//= require turbolinks
//= require_tree .

$(document).ready(function() {
  var authors = ['Shakespeare', 'Tolstoy', 'Austen', 'Dickens', 'Woolf', 'Faulkner', 'Dickinson', 'Dostoyevsky', 'Tolkien', 'Joyce', 'Cervantes', 'Hemingway', 'Poe', 'Nabakov', 'Orwell', 'Christie', 'Márquez', 'Angelou', 'Morrison', 'Shelley', 'Dante', 'Beckett', 'Borges', 'Brontë', 'Chaucer', 'Conrad', 'Eliot', 'Kafka', 'Melville', 'Swift', 'Twain', 'Whitman'];

  $(function () {
    $('#authors').wordsrotator({
      words: authors, // Array of words, it may contain HTML values
      // randomize: true, //show random entries from the words array
      // stopOnHover: false, //stop animation on hover
      // changeOnClick: false, //force animation run on click
      animationIn: "bounceIn", //css class for entrace animation
      animationOut: "bounceOut", //css class for exit animation
      speed: 1750 // delay in milliseconds between two words
    });
  });

  $(function(){ $(document).foundation();
  });
});
