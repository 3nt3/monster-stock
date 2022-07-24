from flask_sqlalchemy import SQLAlchemy
from flask import Flask, jsonify

app = Flask(__name__)
app.config['SQLALCHEMY_DATABASE_URI'] = 'sqlite:///db.sqlite'

db = SQLAlchemy(app)

class Entry(db.Model):
    id = db.Column('')

db.create_all()

@app.route('/stock')
def get_stock():
    return jsonify(Entry.query.all())

if __name__ == '__main__':
    app.run()
