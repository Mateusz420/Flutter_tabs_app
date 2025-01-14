from flask import Flask, jsonify
import model
import time
import tuner_easier_version as tuner

app = Flask(__name__)

@app.route("/tuner", methods=["POST"])
def start_recording():
    model_path = '/Users/mateusz/Desktop/Waz/Tabs_sound_recognition/best_sound_model.pkl'
    label_encoder_path = '/Users/mateusz/Desktop/Waz/Tabs_sound_recognition/label_encoder.pkl'
    user_sound_path = '/Users/mateusz/Desktop/Waz/Tabs_sound_recognition/Sounds/test_sound.wav'

    try:
        predicted_sound = tuner.sound_recognition_standard_tuning(user_sound_path)
        
        return jsonify({"predicted_sound": predicted_sound})
    except Exception as e:
        return jsonify({"error": str(e)}), 500

if __name__ == "__main__":
    app.run(host='0.0.0.0', port=39642)
