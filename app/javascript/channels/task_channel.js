import consumer from "./consumer"
import CableReady from 'cable_ready'

consumer.subscriptions.create({ channel: "TaskChannel", task_id: 1}, {
  connected() {
    console.log('connected to TaskChannel from Javascript');
  },

  received(data) {
    if (data.cableReady) CableReady.perform(data.operations)
  }
});
