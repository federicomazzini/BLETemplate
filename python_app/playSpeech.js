const player = require('play-sound')();

function play() {
    console.log('Playing speech audio file from nodejs');
    player.play('./speech.mp3', (err) => {
        if (err) console.log('Could not play sound: ${err}');
    });
}

play();