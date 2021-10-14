import ApplicationController from './application_controller';
import Sortable from 'sortablejs';
import CableReady from 'cable_ready';
import consumer from '../channels/consumer';

export default class extends ApplicationController {
  static targets = ['form', 'input', 'tasks']
  static values = {
    listId: String
  }

  connect() {
    super.connect();
    if (this.hasTasksTarget) this.initSortable();

    consumer.subscriptions.create({ channel: 'ListChannel', list_id: this.listIdValue }, {
        received(data) {
          if (data.cableReady) { CableReady.perform(data.operations) }
        }
    })
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
    this.stimulate('Task#reorder', event.item, event.newIndex)
  }

  initSortable() {
    Sortable.create(this.tasksTarget, {
      onEnd: (event) => (this.reorder(event)),
      filter: '.complete, .collapse-open'
    });
  }
}
