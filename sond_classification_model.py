import numpy as np
import pandas as pd
import matplotlib.pyplot as plt
import librosa
import sklearn
from sklearn.neighbors import KNeighborsClassifier
from sklearn.preprocessing import StandardScaler, QuantileTransformer, OneHotEncoder, LabelEncoder, MinMaxScaler
from sklearn.ensemble import RandomForestClassifier
from sklearn.pipeline import Pipeline
from sklearn.model_selection import GridSearchCV

#Load the data from the csv metadata of the sounds and modify it so it only uses the data that is needed
def load_csv():
    sounds_csv = pd.read_csv('/Users/mateusz/Desktop/Waz/Tabs_sound_recognition/Sounds/TinySOL_metadata.csv')
    for i in range(len(sounds_csv['Path'])):
        sounds_csv.at[i, 'Path'] = f"/Users/mateusz/Desktop/Waz/Tabs_sound_recognition/Sounds/TinySOL/{sounds_csv.at[i, 'Path']}"
    for i in range(len(sounds_csv['Pitch'])):
        if len(sounds_csv.at[i, 'Pitch']) % 2 == 0:
            sounds_csv.at[i, 'Pitch'] = sounds_csv.at[i, 'Pitch'][0]
        else:
            sounds_csv.at[i, 'Pitch'] = sounds_csv.at[i, 'Pitch'][:2]
    sounds_csv = sounds_csv.sort_values(by='Pitch', ascending=True)
    return sounds_csv

# Load the data that the model will train on
def load_dataset_frequencies():
    sounds_csv = load_csv()
    all_data = []
    # all_frequencies = []
    # all_mfcc = []
    
    for i in range(len(sounds_csv['Path'])):
        y, sr = librosa.load(sounds_csv.at[i, 'Path'])
        y = np.frombuffer(y, dtype=np.int16).astype(np.float32)
        y /= np.max(np.abs(y))
        
        chroma = librosa.feature.chroma_stft(y=y, sr=sr)
        chroma_mean = np.mean(chroma, axis=1)
        # all_frequencies.append(chroma_mean)
        
        mfccs = librosa.feature.mfcc(y=y, sr=sr, n_mfcc=13)
        mfccs_mean = np.mean(mfccs, axis=1)
        # all_mfcc.append(mfccs_mean)
        
        tonez = librosa.feature.chroma_cqt(y=y, sr=sr)
        tonez_mean = tonez.mean(axis=1)
        
        spectral_cotrast = librosa.feature.spectral_contrast(y=y, sr=sr)
        spectral_cotrast_mean = spectral_cotrast.mean(axis=1)
        
        combined_features = np.concatenate((chroma_mean, mfccs_mean, tonez_mean, spectral_cotrast_mean))
        all_data.append(combined_features)
    
    frequencies_df = pd.DataFrame(all_data)
    frequencies_df['Note'] = sounds_csv['Pitch'].values
    
    return frequencies_df

# probably wont be used but it is here
def load_dataset_mfcc():
    sounds_csv = load_csv()
    all_mfcc = []
    
    for i in range(len(sounds_csv['Path'])):
        y, sr = librosa.load(sounds_csv.at[i, 'Path'])
        y = np.frombuffer(y, dtype=np.int16).astype(np.float32)
        y /= np.max(np.abs(y))
        
        
    all_mfcc = pd.DataFrame(all_mfcc)
    all_mfcc['Note'] = sounds_csv['Pitch'].values
    
    all_mfcc.columns = all_mfcc.columns.astype(str)

    return all_mfcc

# Load the data from the sample that the modell will need to predict 
def load_wav(path):
    y, sr = librosa.load(path)
    y = np.frombuffer(y, dtype=np.int16).astype(np.float32)
    y /= np.max(np.abs(y))
    chroma = librosa.feature.chroma_stft(y=y, sr=sr)
    chroma_mean = np.mean(chroma, axis=1)
    
    mfcc = librosa.feature.mfcc(y=y, sr=sr, n_mfcc=13)
    mfcc_mean = np.mean(mfcc, axis=1)
    
    tonez = librosa.feature.chroma_cqt(y=y, sr=sr)
    tonez_mean = tonez.mean(axis=1)
    
    spectral_cotrast = librosa.feature.spectral_contrast(y=y, sr=sr)
    spectral_cotrast_mean = spectral_cotrast.mean(axis=1)
    
    combined_fatures = np.concatenate((chroma_mean, mfcc_mean, tonez_mean, spectral_cotrast_mean))
    
    return combined_fatures.reshape(1, -1)

def model():
    frequencies = load_dataset_frequencies()
    X = frequencies.drop(columns=['Note'])
    y = frequencies['Note']
    
    label_encoder = LabelEncoder()
    y_encoded = label_encoder.fit_transform(y)

    pipe = Pipeline([
    ("scaler", MinMaxScaler()),
    ("classifier", RandomForestClassifier())
    ])

    param_grid = {
        'classifier__n_estimators': [100, 200, 300],
        'classifier__max_depth': [10, 20, None],
        'classifier__min_samples_split': [2, 5, 10],
         'classifier__min_samples_leaf': [1, 2, 4],
        'classifier__bootstrap': [True, False]
    }

    grid_search = GridSearchCV(pipe, param_grid, cv=5, scoring='accuracy')
    grid_search.fit(X, y_encoded)
    
    prediction = grid_search.predict(load_wav('/Users/mateusz/Desktop/Waz/Tabs_sound_recognition/Sounds/C_sound.wav'))
    prediction = label_encoder.inverse_transform(prediction)
    
    print(f"Predicted sound: {prediction}")
    print(f"Best parameters: {grid_search.best_params_}")
    print(f"Best cross-validation accuracy: {grid_search.best_score_}")

if __name__ == "__main__": 
    model()

