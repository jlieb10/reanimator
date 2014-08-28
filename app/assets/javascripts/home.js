(function(){

  $( document ).on( 'page:change', function(){
    var attachNavAnimationOnMouseClose,
        detachNavAnimationOnMouseClose,
        $nav = $( 'nav.top-bar' );

    attachNavAnimationOnMouseClose = function ( ) {
      $( document ).on( 'mousemove', 'body, nav.top-bar', function( e ){
        var $this = $( this );

        e.stopPropagation();
        if( e.clientY < 90 || $this.is( 'nav.top-bar' )) {
          $nav.slideDown( 'fast' );
        } else {
          $nav.slideUp( 'fast' );
        }
      });
    };

    detachNavAnimationOnMouseClose = $.prototype.off.bind( $( document ), 'mousemove', 'body, nav.top-bar' );

    if( $( window ).width() >= 640 ) attachNavAnimationOnMouseClose();

    $( window ).on( 'resize', function() {
      if( $( window ).width() < 640 ) {
        detachNavAnimationOnMouseClose(); 
        $nav.slideDown( 'fast' );
      }
      else {
        attachNavAnimationOnMouseClose();
        $nav.slideUp( 'fast' );

      }
    });

  });


})();