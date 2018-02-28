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
