import { Grid } from './grid';

export const initPagination = $(document).on('ready', () => {
  for (let container of $('[data-pagination]')) {
    new Pagination(container)
  }
});

export class Pagination {

  constructor(container) {
    this.currentPage = 0;
    this.showNextPage = this.showNextPage.bind(this);
    this.container = $(container);
    this.paginationName = this.container.data('pagination');
    this.pageLength = this.container.data('page-length') || 10;
    this.initPages();
    this.showNextPage();
    this.bindClickEvent();
  }

  initPages() {
    const iterable = this.container.find('.paginated');
    for (let idx = 0; idx < iterable.length; idx++) {
      const item = iterable[idx];
      const pageNumber = parseInt((idx + this.pageLength) / this.pageLength);
      $(item).attr('data-page', pageNumber);
    }
  }

  showNextPage(event = null) {
    this.currentPage++;
    this.container.find(`[data-page='${this.currentPage}']`).addClass('paginated--show');
    Grid.init();
    if (this.container.find(`[data-page='${this.currentPage + 1}']`).length === 0) {
      $(`[data-pagination-loader='${this.paginationName}']`).hide();
    }
  }

  bindClickEvent() {
    $(`[data-pagination-loader='${this.paginationName}']`).click(this.showNextPage);
  }
}
