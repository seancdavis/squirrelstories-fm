export const activeToggle = $(document).on('ready', () =>
  $(document).on('click', '[data-active-toggle]', function(event) {
    if(
      $(event.target).is('[data-block-active-toggle]') ||
      ($(event.target).parents('[data-block-active-toggle]').length > 0)
    ) { return true; }
    event.preventDefault();
    const object = $(this).data('active-toggle');
    for (let selector in object) {
      const classes = object[selector];
      $(selector).toggleClass(classes);
    }
  })
);
