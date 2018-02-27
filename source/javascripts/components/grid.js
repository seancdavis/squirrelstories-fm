export { Grid, initGrid }

const initGrid = $(document).ready(() => setTimeout(Grid.init, 10));

class Grid {

  static init() {
    $('.masonry').masonry({
      percentPosition: true,
      columnWidth: '.masonry--sizer',
      itemSelector: '.masonry--tile',
      gutter: 16
    });
    return $('.masonry').removeClass('invisible');
  }
}
