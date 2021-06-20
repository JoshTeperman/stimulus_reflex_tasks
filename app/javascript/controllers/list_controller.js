import ApplicationController from './application_controller';
import Sortable from 'sortablejs';

export default class extends ApplicationController {
  static targets = ['form', 'input', 'tasks']

  connect() {
    super.connect();
    Sortable.create(this.tasksTarget);
  }

  beforeCreateTask(element) {
    element.querySelectorAll('input').forEach(input => input.blur());
    element.classList.add('form-disabled');
  }

  createTaskSuccess() {
    this.formTarget.reset();
    this.inputTarget.focus();
  }
}
