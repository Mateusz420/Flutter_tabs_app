from flask import Flask, jsonify
import json

app = Flask(__name__)

@app.route('/get-tabs', methods=['GET'])
def get_tabs():
    try:
        with open('/Users/mateusz/Desktop/Waz/Tabs_sound_recognition/tabs.json', 'r') as f:
            tab_data = json.load(f)
        return jsonify(tab_data)
    except Exception as e:
        return jsonify({"error": str(e)}), 500

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=39641)
