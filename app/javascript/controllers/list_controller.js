import ApplicationController from './application_controller';
import Sortable from 'sortablejs';

export default class extends ApplicationController {
  static targets = ['form', 'input', 'tasks']

  connect() {
    super.connect();

    Sortable.create(this.tasksTarget, {
      onEnd: (event) => (this.reorder(event)),
      filter: '.completed'
    });
  }

  beforeCreateTask(element) {
    element.querySelectorAll('input').forEach(input => input.blur());
    element.classList.add('form-disabled');
  }

  createTaskSuccess() {
    this.formTarget.reset();
    this.inputTarget.focus();
  }

  reorder(event) {
    console.log(event);
    this.stimulate('Task#reorder', event.item, event.newIndex)
  }
}
