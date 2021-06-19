import ApplicationController from './application_controller';

export default class extends ApplicationController {
  static targets = ['form', 'input']

  beforeCreateTask(element) {
    element.querySelectorAll('input').forEach(input => input.blur());
    element.classList.add('form-disabled');
  }

  createTaskSuccess() {
    this.formTarget.reset();
    this.inputTarget.focus();
  }
}
