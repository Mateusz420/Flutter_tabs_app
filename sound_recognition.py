import wave
import librosa.feature
import pyaudio
import librosa
import numpy as np
import pandas as pd
import matplotlib.pyplot as plt
import model

def sound_recording(model_path, label_encoder_path, user_sound_path):
    running = True
    while running:
        p = pyaudio.PyAudio()
        stream = p.open(format=pyaudio.paInt16, channels=1, rate=44100, input=True, frames_per_buffer=1024)
        
        frames = []
        
        for i in range(0, int(44100 / 44100)):
            data = stream.read(44100)
            frames.append(data)
        
        stream.stop_stream()
        
        with wave.open(user_sound_path, 'wb') as wf:
            wf.setnchannels(1)
            wf.setsampwidth(p.get_sample_size(pyaudio.paInt16))
            wf.setframerate(44100)
            wf.writeframes(b''.join(frames))
            wf.close()
        
        predicted_sound = model.predict_sound(model_path, user_sound_path, label_encoder_path)
        return predicted_sound
        
if(__name__ == "__main__"):
    dataset_path = '/Users/mateusz/Desktop/Waz/Tabs_sound_recognition/Sounds/TinySOL_metadata.csv'
    sounds_path = '/Users/mateusz/Desktop/Waz/Tabs_sound_recognition/Sounds/TinySOL'

    model_path = '/Users/mateusz/Desktop/Waz/Tabs_sound_recognition/best_sound_model.pkl'
    label_encoder_path = '/Users/mateusz/Desktop/Waz/Tabs_sound_recognition/label_encoder.pkl'
    wav_path = '/Users/mateusz/Desktop/Waz/Tabs_sound_recognition/Sounds/C_sound.wav'
    user_sound_path = '/Users/mateusz/Desktop/Waz/Tabs_sound_recognition/Sounds/test_sound.wav'
    
    predicted_sound = sound_recording(model_path, label_encoder_path, user_sound_path)
    print(predicted_sound)
    