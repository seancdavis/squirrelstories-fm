
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

# ---------------------------------------- | Shuffling

(($) ->

  $.fn.shuffle = ->
    allElems = @get()

    getRandom = (max) ->
      Math.floor Math.random() * max

    shuffled = $.map(allElems, ->
      random = getRandom(allElems.length)
      randEl = $(allElems[random]).clone(true)[0]
      allElems.splice random, 1
      randEl
    )
    @each (i) ->
      $(this).replaceWith $(shuffled[i])
      return
    $ shuffled

  return
) jQuery

# ---------------------------------------- | Random Quote

$(document).on('ready', () ->
  for quoteSet in $('[data-random-quotes]')
    n = parseInt($(quoteSet).data('random-quotes'))
    quotes = $(quoteSet).find('.quote--random').shuffle().toArray()
    $(quote).addClass('quote--random-show') for quote in quotes.slice(0, n)
)

# ---------------------------------------- | Pagination

class Pagination

  currentPage: 0

  constructor: (container) ->
    @container = $(container)
    @paginationName = @container.data('pagination')
    @showNextPage()
    @bindClickEvent()

  showNextPage: (event = null) =>
    @currentPage++
    @container.find("[data-page='#{@currentPage}']").addClass('paginated--show')
    if @container.find("[data-page='#{@currentPage + 1}']").length == 0
      $("[data-pagination-loader='#{@paginationName}']").hide()

  bindClickEvent: ->
    $("[data-pagination-loader='#{@paginationName}']").click(@showNextPage)

$(document).on('ready', () ->
  new Pagination(container) for container in $('[data-pagination]')
)
