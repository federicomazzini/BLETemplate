const player = require('play-sound')();

function play() {
    console.log('Playing bell audio file from nodejs');
    player.play('./bell.mp3', (err) => {
        if (err) console.log('Could not play sound: ${err}');
    });
}

play();