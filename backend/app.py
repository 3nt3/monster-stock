from flask_sqlalchemy import SQLAlchemy
from flask import Flask, jsonify, request
from datetime import datetime
from datetime import timezone
import json
import calendar

app = Flask(__name__)
app.config['SQLALCHEMY_DATABASE_URI'] = 'sqlite:///db.sqlite'

db = SQLAlchemy(app)

class Entry(db.Model):
    id = db.Column('id', db.Integer, primary_key=True)
    count = db.Column('count', db.Integer)
    created_at = db.Column('created_at', db.DateTime, default=datetime.now(timezone.utc))
    type_of_thing = db.Column('type_of_thing', db.String)

    def __init__(self, count, type_of_thing):
        self.count = count
        self.type_of_thing = type_of_thing

    def __repr__(self):
        return 'Post <%d %s>' % (self.count, self.type_of_thing)

db.create_all()

@app.route('/stock')
def get_stock():
    return jsonify([{
        'id': entry.id,
        'count': entry.count,
        'created_at': calendar.timegm(entry.created_at.timetuple()),
        'type_of_thing': entry.type_of_thing
    } for entry in Entry.query.all()])

@app.route('/stock', methods=['POST'])
def post_stock():
    body = json.loads(request.data)
    count = body['count']
    type_of_thing = body['type_of_thing']

    new_entry = Entry(count, type_of_thing)
    db.session.add(new_entry)
    db.session.commit()
    
    return jsonify({
        'id': new_entry.id,
        'count': new_entry.count,
        'created_at': calendar.timegm(new_entry.created_at.timetuple()),
        'type_of_thing': new_entry.type_of_thing
    })
    
if __name__ == '__main__':
    app.run(debug=True)
