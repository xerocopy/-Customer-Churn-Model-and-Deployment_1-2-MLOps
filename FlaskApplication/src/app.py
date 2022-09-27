import os
from pathlib import Path
from dotenv import load_dotenv
from flask import Flask, jsonify, request, redirect, url_for, render_template
load_dotenv(Path(".env"))
import pandas as pd
import os
import json
import requests

if os.environ.get("ENV", "dev") == "prod":
    load_dotenv(Path(".env.prod"))
if os.environ.get("ENV", "dev") == "dev":
    load_dotenv(Path(".env.dev"))

from logging_module import logger
from predictor import predict
app = Flask(__name__)

@app.route("/health-status")
def get_health_status():
    logger.debug("Health check api version 2")
    resp = jsonify({"status": "I am alive, version 2"})
    resp.status_code = 200
    return resp

@app.route("/churn-prediction", methods=['GET','POST']) ## add 'GET' method to allow access from webpage
def churn_prediction():
    logger.debug("Churn Prediction API Called")
    if request.method == 'GET':
        return f"Try going to '/submit-url' to submit data url, else use 'https://churn-prediction-data-123.s3.amazonaws.com/Churn_Modelling.csv'."
    
    if request.method == 'POST':
        form_data = request.form
        #return render_template('data.html',form_data = form_data)
        url = form_data['data url']

        print(url)
        df = pd.read_csv(url)
        status, result = predict(df)
        print(status, result)
        if status == 200:
            result = json.loads(result.to_json(orient="records"))
            resp = jsonify({"result": result})
        else:
            resp = jsonify({"errorDetails": result})
            resp.status_code = status
        return resp

    
@app.route("/submit-url", methods=['GET','POST'])
def submit_url():
    logger.debug("Submit URL API Called")
    return render_template("form.html")
    
    

if __name__ == "__main__":
    app.run(debug = True)