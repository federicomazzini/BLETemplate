import os
from threading import Timer
from mutagen.mp3 import MP3

time_currently_set = False
default_player = 'mplayer'
bell_file_path = './bell.mp3'
speech_file_path = './speech.mp3'
default_delay = 3.0
speech_session_min_ratio = 2.0

def play_bell_command():
    return default_player + " " + bell_file_path

def play_speech_command():
    return default_player + " " + speech_file_path

def get_speech_allowed(session_seconds_duration):
    duration = audio_duration(speech_file_path)
    if (session_seconds_duration / speech_session_min_ratio) > duration :
        print("Speech will play")
        return True
    else:
        print("Speech won\'t play")
        return False

def get_speech_start_time(session_seconds_duration):
    duration = audio_duration(speech_file_path)
    return session_seconds_duration + default_delay - duration

def audio_duration(file_name):
    audio = MP3(file_name)
    return audio.info.length

def play_speech():
    print("Playing speech")
    command = play_speech_command()
    os.system(command)

def play_start_bell():
    print("Playing start bell")
    command = play_bell_command()
    os.system(command)

def play_end_bell():
    print("Playing end bell")
    command = play_bell_command()
    os.system(command)
    global time_currently_set
    time_currently_set = False

def play_session(minutes):
    global time_currently_set
    time_currently_set = True

    global default_delay
    session_seconds_duration = minutes*60
    print("Session will last " + str(int(minutes)) + " minutes")

    print("Starting 1st bell Timer")
    timer1 = Timer(default_delay, play_start_bell)
    timer1.start()

    speech_allowed = get_speech_allowed(session_seconds_duration)
    if speech_allowed:
        speech_start_time = get_speech_start_time(session_seconds_duration)
        print("Starting speech Timer")
        timer2 = Timer(float(speech_start_time), play_speech)
        timer2.start()

    print("Starting 2nd bell Timer")
    timer3 = Timer(float(session_seconds_duration + default_delay * 2), play_end_bell)
    timer3.start()

