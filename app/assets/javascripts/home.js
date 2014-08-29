(function(){

  $( document ).on( 'page:change', function(){

    var attachNavAnimationOnMouseClose,
        detachNavAnimationOnMouseClose,
        $nav = $( 'nav.top-bar' ),
        $win = $( window ),
        $doc = $( document );

    attachNavAnimationOnMouseClose = function ( ) {
      $doc.on( 'mousemove', 'body, nav.top-bar', function( e ){
        var $this = $( this );

        e.stopPropagation();
        if( e.clientY < 90 || $this.is( 'nav.top-bar' )) {
          $nav.slideDown( 'fast' );
        } else {
          $nav.slideUp( 'fast' );
        }
      });
    };

    detachNavAnimationOnMouseClose = $.prototype.off.bind( $doc, 'mousemove', 'body, nav.top-bar' );
    
    if( $win.width() >= 640 ) attachNavAnimationOnMouseClose();

    $win.on( 'resize', function() {
      if( $win.width() < 640 ) {
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