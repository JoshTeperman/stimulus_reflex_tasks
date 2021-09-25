import ApplicationController from './application_controller';
import consumer from '../channels/consumer';
import CableReady from 'cable_ready';

export default class extends ApplicationController {
  static values = {
    taskId: String
  }

  connect() {
    super.connect()

    consumer.subscriptions.create({ channel: 'TaskChannel', task_id: this.taskIdValue }, {
      connected() {
        console.log('connected to TasksChannel from inside Stimulus Controller')
      },
      received(data) {
        if (data.cableReady) CableReady.perform(data.operations)
      }
    })
  }
}
