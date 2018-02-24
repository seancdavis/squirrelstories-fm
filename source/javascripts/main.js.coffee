
# ---------------------------------------- | Masonry / Grid

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

# ---------------------------------------- | Active Toggle

$(document).on('ready', () ->
  $(document).on('click', '[data-active-toggle]', (event) ->
    return true if(
      $(event.target).is('[data-block-active-toggle]') ||
      $(event.target).parents('[data-block-active-toggle]').length > 0
    )
    event.preventDefault()
    for selector, classes of $(this).data('active-toggle')
      $(selector).toggleClass(classes)
  )
)

# ---------------------------------------- | Random Quote

$(document).on('ready', () ->
  for quoteSet in $('[data-random-quotes]')
    n = parseInt($(quoteSet).data('random-quotes'))
    quotes = _.shuffle($(quoteSet).find('.quote--random').toArray())
    $(quote).addClass('quote--random-show') for quote in _.take(quotes, n)
)
