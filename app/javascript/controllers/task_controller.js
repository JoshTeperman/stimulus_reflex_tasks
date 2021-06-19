import ApplicationController from './application_controller';

export default class extends ApplicationController {
  delete(event) {
    const confirmation = confirm("Delete task?")
    if (confirmation) { this.stimulate('Task#delete', event.target.dataset.id) }
  }
}
