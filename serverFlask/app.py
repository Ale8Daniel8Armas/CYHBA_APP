from flask import Flask, request, jsonify
import pickle
import numpy as np
import pandas as pd
import logging
from datetime import datetime

logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)

app = Flask(__name__)

MODEL_PATH = 'modelo_decision_tree.pkl'
ENCODER_PATH = 'label_encoders.pkl'

class HeartDiseasePredictor:
    def __init__(self):
        self.model = None
        self.label_encoder = None
        self.load_model()

    def load_model(self):
        """Cargar el modelo y el encoder"""
        try:
            with open(MODEL_PATH, 'rb') as file:
                self.model = pickle.load(file)
            with open(ENCODER_PATH, 'rb') as file:
                self.label_encoder = pickle.load(file)
            logger.info("Modelo y encoder cargados exitosamente")
        except Exception as e:
            logger.error(f"Error cargando el modelo: {str(e)}")
            raise

    def predict_disease(self, input_data):
        """Realizar predicción y devolver las dos enfermedades más probables"""
        try:
            input_df = pd.DataFrame([input_data])
            prediction_probs = self.model.predict_proba(input_df)[0]
            class_indices = np.argsort(prediction_probs)[-2:][::-1]
            results = [
                {
                    'disease': str(self.label_encoder['Cause_name'].inverse_transform([self.model.classes_[idx]])[0]),
                    'probability': round(float(prediction_probs[idx] * 100), 2)
                }
                for idx in class_indices if prediction_probs[idx] > 0.1
            ]
            return results
        except Exception as e:
            logger.error(f"Error en predicción: {str(e)}")
            raise

predictor = HeartDiseasePredictor()

@app.route('/predict', methods=['POST'])
def predict():
    try:
        data = request.get_json()
        if not data:
            return jsonify({'message': 'No se proporcionaron datos'}), 400
        
        predictions = predictor.predict_disease(data)
        return jsonify({'prediction': predictions})
    except Exception as e:
        logger.error(f"Error en predicción: {str(e)}")
        return jsonify({'message': str(e)}), 500

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000, debug=True)