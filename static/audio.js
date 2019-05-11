(function() {

"use strict";

// Core Audio

let buffers = {}
let tracks = {}

const AudioContext = window.AudioContext || window.webkitAudioContext;
const audioCtx = new AudioContext();

async function getMusic(filepath) {
  const response = await fetch(filepath);
  const arrayBuffer = await response.arrayBuffer();
  const audioBuffer = await audioCtx.decodeAudioData(arrayBuffer);
  return audioBuffer;
}

async function loadMusic(filePath) {
  const track = await getMusic(filePath);
  return track;
}

let offset = 0;

function playTrack(audioBuffer) {
  const trackSource = audioCtx.createBufferSource();
  trackSource.buffer = audioBuffer;
  trackSource.connect(audioCtx.destination);
  trackSource.loop = true;

  if (offset == 0) {
    trackSource.start();
    offset = audioCtx.currentTime;
  } else {
    trackSource.start(0, audioCtx.currentTime - offset);
  }

  return trackSource;
}

function stopTrack(audioBuffer) {
  const trackSource = audioCtx.createBufferSource();
  trackSource.buffer = audioBuffer;
  trackSource.connect(audioCtx.destination);

  if (offset == 0) {
    trackSource.start();
    offset = audioCtx.currentTime;
  } else {
    trackSource.start(0, audioCtx.currentTime - offset);
  }

  return trackSource;
}

// Message Handling

function init(theTracks, startingTrack) {
  theTracks.forEach((track, i) => {
    loadMusic(track + ".wav").then((buffer) => {
      buffers[track] = buffer;
      console.log("done: " + track);
      if (track === startingTrack) {
        play(track);
      }
    });
  });
}

function play(track) {
  let buffer = buffers[track];
  if (buffer) {
    tracks[track] = playTrack(buffer);
  } else {
    console.warn("track '" + track + "' not ready yet!");
  }
}

function stop(track) {
  console.log("stop: " + track);
  if (tracks[track]) {
    tracks[track].stop();
  } else {
    console.warn("stop: track '" + track + "' not found!");
  }
}

app.ports.audio.subscribe(function(data) {
  let name = data.name;
  let args = data.args;

  switch (name) {
    case "init":
      init(args.tracks, args.startingTrack);
      break;
    case "play":
      play(args.track);
      break;
    case "stop":
      stop(args.track);
      break;
    default:
      console.warn("audio subscription: unknown command");
      break;
  }
});

})();
