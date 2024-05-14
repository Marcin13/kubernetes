# Import the Flask class
from flask import Flask

# Create an instance of the Flask class
app = Flask(__name__)

# Define a route for the root URL ("/") that returns a hello message
@app.route('/')
def hello():
    return 'Hello, Flask in Docker!'

# Run the app if this script is executed
if __name__ == '__main__':
    app.run(debug=True, host='0.0.0.0', port=5000)
