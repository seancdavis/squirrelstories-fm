class Grid

  @init: ->
    $('.masonry').masonry(
      percentPosition: true
      columnWidth: '.masonry--sizer'
      itemSelector: '.masonry--tile'
      gutter: 16
    )
    $('.masonry').removeClass('invisible')

$(document).ready(() ->
  setTimeout(Grid.init, 10)
)
