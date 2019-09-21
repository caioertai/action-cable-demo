import consumer from "./consumer";

const channelConfig = {
  // Same name as the Channel class you generated in Rails
  channel: "WaveChannel"
};

const channelCallbacks = {
  // Called when the subscription is created.
  initialized: () => {
    console.log("Just subscribed to WaveChannel")
  },
  // Called when a broadcast is received
  received: (data) => {
    alert(data)
  }
};

const initWaveChannel = () => {
  consumer.subscriptions.create(channelConfig, channelCallbacks);
}

export { initWaveChannel };