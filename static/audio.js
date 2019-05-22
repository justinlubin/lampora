(function() {

"use strict";

// Core Audio

let minDuration = null;

let buffers = {};
let sources = {};
let gainNodes = {};

const AudioContext = window.AudioContext || window.webkitAudioContext;
const audioCtx = new AudioContext();

async function getMusic(path) {
  const response = await fetch(path);
  const arrayBuffer = await response.arrayBuffer();
  const audioBuffer = await audioCtx.decodeAudioData(arrayBuffer);
  return {
    path: path,
    buffer: audioBuffer
  };
}

let firstOffset = null;
let currentOffset = 0;

const fadeTime = 0;
function playSynced(path) {
  const source = audioCtx.createBufferSource();
  source.buffer = buffers[path];
  source.loop = true;
  source.loopEnd = minDuration;

  const gainNode = audioCtx.createGain();
  source.connect(gainNode);
  gainNode.connect(audioCtx.destination);

  gainNode.gain.setValueAtTime(1, audioCtx.currentTime);

  if (firstOffset == null) {
    firstOffset = audioCtx.currentTime;
  }

  currentOffset = audioCtx.currentTime % minDuration;

  let offset = currentOffset - firstOffset;

  if (offset < 0) {
    source.start(0, 0);
  } else {
    source.start(0, offset);
  }

  sources[path] = source;
  gainNodes[path] = gainNode;

  console.log("play: " + path);
}

function stop(path) {
  if (sources[path]) {
    sources[path].stop(audioCtx.currentTime + fadeTime);

    sources[path] = null;
    gainNodes[path] = null;
  }
}

// Message Handling

const msgLoaded = {name: "loaded", args: []};

function init(allTracks) {
  Promise.all(allTracks.map(getMusic)).then(musics => {
    musics.forEach(music => {
      buffers[music.path] = music.buffer;

      if (minDuration == null || music.buffer.duration < minDuration) {
        minDuration = music.buffer.duration;
      }

      console.log("done: " + music.path);
    });
    app.ports.audioToElm.send(msgLoaded);
  });
}

function set(tracklist) {
  Object.keys(sources).forEach(stop);
  tracklist.forEach(playSynced);
}

app.ports.audioToJs.subscribe(function(data) {
  let name = data.name;
  let args = data.args;

  switch (name) {
    case "init":
      init(args.allTracks);
      break;
    case "set":
      set(args.tracklist);
      break;
    default:
      console.warn("audioToJs subscription: unknown command");
      break;
  }
});

})();
