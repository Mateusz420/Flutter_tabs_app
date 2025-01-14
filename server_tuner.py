from flask import Flask, jsonify
import model
import time
import sound_recognition

app = Flask(__name__)

@app.route("/start-recording", methods=["POST"])
def start_recording():
    model_path = '/Users/mateusz/Desktop/Waz/Tabs_sound_recognition/best_sound_model.pkl'
    label_encoder_path = '/Users/mateusz/Desktop/Waz/Tabs_sound_recognition/label_encoder.pkl'
    user_sound_path = '/Users/mateusz/Desktop/Waz/Tabs_sound_recognition/Sounds/test_sound.wav'

    try:
        predicted_sound = sound_recognition.sound_recording(model_path, label_encoder_path, user_sound_path)
        
        return jsonify({"predicted_sound": predicted_sound})
    except Exception as e:
        return jsonify({"error": str(e)}), 500

if __name__ == "__main__":
    app.run(host='0.0.0.0', port=39640)
