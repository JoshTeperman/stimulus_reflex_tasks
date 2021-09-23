// use @rails/action_cable consumer to connect to CableReady channels from Javascript

import consumer from './consumer';
import CableReady from 'cable_ready';

consumer.subscriptions.create("ListsChannel", {
  connected() {
    console.log('connected to ListsChannel from Javascript');
  },
  received(data) {
    // request received from @rails/action_cable
    console.log(data);
    if (data.cableReady) CableReady.perform(data.operations)
  }
})
