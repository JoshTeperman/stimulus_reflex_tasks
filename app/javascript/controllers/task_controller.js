import ApplicationController from './application_controller';

export default class extends ApplicationController {
  static targets = ['checkbox', 'collapse']

  connect() {
    super.connect()
    $(this.collapseTarget).on('show.bs.collapse', () => {
      this.checkboxTarget.classList.add('d-none')
      this.element.classList.add('collapse-open')
    })

    $(this.collapseTarget).on('hide.bs.collapse', () => {
      this.checkboxTarget.classList.remove('d-none')
      this.element.classList.remove('collapse-open')
    })
  }

  delete(event) {
    event.preventDefault()
    const confirmation = confirm("Delete task?")
    if (confirmation) { this.stimulate('Task#delete', event.target) }
  }
}
