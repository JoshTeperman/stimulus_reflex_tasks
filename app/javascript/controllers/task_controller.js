import ApplicationController from './application_controller';

export default class extends ApplicationController {
  static targets = ['checkbox', 'collapse']

  connect() {
    $(this.collapseTarget).on('show.bs.collapse', (event) => {
      this.checkboxTarget.classList.add('d-none')
    })

    $(this.collapseTarget).on('hide.bs.collapse', (event) => {
      this.checkboxTarget.classList.remove('d-none')
    })
  }

  delete(event) {
    const confirmation = confirm("Delete task?")
    if (confirmation) { this.stimulate('Task#delete', event.target) }
  }
}
