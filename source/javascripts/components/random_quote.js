export const randomQuote = $(document).on('ready', function() {
  for (let quoteSet of $('[data-random-quotes]')) {
    const n = parseInt($(quoteSet).data('random-quotes'));
    const quotes = $(quoteSet).find('.quote--random').shuffle().toArray();
    for (let quote of quotes.slice(0, n)) {
      $(quote).addClass('quote--random-show');
    }
  }
});
