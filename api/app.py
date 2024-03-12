from flask import Flask, request, jsonify
from flask_sqlalchemy import SQLAlchemy
from sqlalchemy import or_
import os
import requests

app = Flask(__name__)
app.config['SQLALCHEMY_DATABASE_URI'] = 'postgresql://mapitdev:mapit2024@104.196.188.212/mapitdb'
db = SQLAlchemy(app)
##//Aca se crea la clase "User" para la tabla "users"\\
class Users(db.Model):
    __tablename__ = 'users'
    userid = db.Column(db.String, primary_key=True)
    username = db.Column(db.String)
    userimage = db.Column(db.String)
    def to_dict(self):
        return {
            'userid': self.userid,
            'username': self.username,
            'userimage': self.userimage
            # Add other fields as needed
        }
class Point(db.Model):
    __tablename__ = 'places'
    places_id = db.Column(db.String, primary_key=True)
    post_title = db.Column(db.String)
    latitud = db.Column(db.Numeric)
    longitude = db.Column(db.Numeric)
    post_text = db.Column(db.String)
    url_post_photo = db.Column(db.String)
    user_id = db.Column(db.String)
    private = db.Column(db.Boolean)
    temporary  = db.Column(db.Boolean)

class Friend(db.Model):
    __tablename__ = 'friends'
    id = db.Column(db.Integer, primary_key=True, autoincrement=True)
    user1_id = db.Column(db.String, db.ForeignKey('users.userid'))
    user2_id = db.Column(db.String, db.ForeignKey('users.userid'))
    user = db.relationship('Users', backref='friends', primaryjoin="or_(Friend.user1_id==Users.userid, Friend.user2_id==Users.userid)")
@app.route('/user', methods=['POST'])
@app.route('/user/<user_id>', methods=['GET', 'DELETE', 'PUT'])
def user_endpoint(user_id = None):
    if request.method == 'GET':
        user = Users.query.get(user_id)
        if user:
            return jsonify(user.to_dict()), 200
        else:
            return jsonify({"message":f"No se encontró el usuario con ID {user_id}"}), 404
    elif request.method == 'POST':
        user_data = request.json
        new_user = Users(**user_data)
        db.session.add(new_user)
        db.session.commit()
        return jsonify({"message": "Usuario agregado correctamente"}), 201
    elif request.method == 'DELETE':
        user = Users.query.get(user_id)
        if user:
            db.session.delete(user)
            db.session.commit()
            return jsonify({"message":f"Usuario con ID {user_id} eliminado correctamente"}), 200
        else:
            return jsonify({"message":f"No se encontro el usuario con ID {user_id}"}), 404
    elif request.method == 'PUT':
        user_data = request.json
        user = Users.query.get(user_id)
        if user:
            for key, value in user_data.items(): setattr(user, key, value)
            db.session.commit()
            return jsonify({"message":f"Usuario con ID {user_id} actualizado correctamente"}), 200
        else:
            return jsonify({"message":f"No se encontró el usuario con ID {user_id}"}), 404
# PLACES INTERACTIONS
@app.route('/places', methods=['POST', 'DELETE'])
@app.route('/places/<id>', methods=['PUT', 'GET'])
#LINK JSON COMPLETO
def places(id = None):
    if (request.method == 'POST'): #Agregar Punto
        datos_punto = request.json
        nuevo_punto = Point(**datos_punto)
        db.session.add(nuevo_punto)
        db.session.commit()
        return jsonify({"message": "Usuario agregado correctamente"}), 201
    elif (request.method == 'GET'):
        if id is None:
            return jsonify({"error": "Se requiere el parámetro 'user_id'"}), 400
        lugares = Point.query.filter_by(user_id=id).all()
        lugares_json = [{"places_id": lugar.places_id,
                        "post_title": lugar.post_title,
                        "latitud": lugar.latitud,
                        "longitude": lugar.longitude,
                        "post_text": lugar.post_text,
                        "url_post_photo": lugar.url_post_photo,
                        "user_id": lugar.user_id,
                        "temporary": lugar.temporary} for lugar in lugares]
        return jsonify(lugares_json), 200
 # PASARLE UN DICT AL DELETe
#https://mapit-kezkcv4lwa-ue.a.run.app/VARIABLE
    elif request.method == 'DELETE':
        request_json = request.json
        if 'places_id' in request_json:
            lugar_id = request_json['places_id']
            lugar = Point.query.filter_by(places_id=lugar_id).first()
            if lugar:
                db.session.delete(lugar)
                db.session.commit()
                return jsonify("Punto eliminado correctamente"), 200
            else:
                return jsonify("No se ha podido eliminar el punto"), 404
        else:
            return jsonify("El payload JSON no contiene el campo 'places_id'"), 400
#https://mapit-kezkcv4lwa-ue.a.run.app/VARIABLE_PLACES_ID + JSON COMPLETO
    elif (request.method == 'PUT'):
        request_json = request.json
        lugar_id = request_json['places_id']
        lugar = Point.query.filter_by(places_id=lugar_id).first()
        if not lugar:
            return jsonify("No se ha encontrado el punto"), 404
        lugar.post_title = request_json.get('post_title', lugar.post_title)
        lugar.latitud = request_json.get('latitud', lugar.latitud)
        lugar.longitude = request_json.get('longitude', lugar.longitude)
        lugar.post_text = request_json.get('post_text', lugar.post_text)
        lugar.url_post_photo = request_json.get('url_post_photo', lugar.url_post_photo)
        lugar.user_id = request_json.get('user_id', lugar.user_id)
        lugar.private = request_json.get('private', lugar.private)
        lugar.temporary = request_json.get('temporary', lugar.temporary)
        db.session.commit()
        return jsonify("Punto actualizado correctamente"), 200
@app.route('/friends', methods=['POST','DELETE'])
@app.route('/friends/<id>', methods=['GET'])
def friends(id = None):
    if request.method == 'POST':
        datos_amistad = request.json
        nueva_amistad = Friend(**datos_amistad)
        amistad_reversa = Friend(user1_id=datos_amistad['user2_id'], user2_id=datos_amistad['user1_id'])
        db.session.add(nueva_amistad)
        db.session.add(amistad_reversa)
        db.session.commit()
        return jsonify({"message": "amigo agregado correctamente"}), 201
    if request.method == 'GET':
        if id is None:
            return jsonify("Se requiere el parametro 'user_id'")
        friends_data = db.session.query(Friend.user2_id, Users.username).\
            join(Users, or_(Friend.user1_id == Users.userid, Friend.user2_id == Users.userid)).\
            filter(Friend.user1_id == id).all()
        unique_friend_ids = set()
        friends_list = []
        for friend_id, username in friends_data:
            if friend_id not in unique_friend_ids:
                unique_friend_ids.add(friend_id)
                friends_list.append({'friend_id': friend_id, 'username': username})
        return jsonify(friends_list), 200
    if request.method == 'DELETE':
        data = request.json
        if 'user1_id' not in data or 'user2_id' not in data:
            return jsonify({'error': 'Both user1_id and user2_id are required'}), 400
        user1_id = data['user1_id']
        user2_id = data['user2_id']
        amistad = Friend.query.filter_by(user1_id=user1_id, user2_id=user2_id).first()
        amistad_reversa = Friend.query.filter_by(user1_id=user2_id, user2_id=user1_id).first()
        if amistad and amistad_reversa:
            db.session.delete(amistad)
            db.session.delete(amistad_reversa)
            db.session.commit()
            return jsonify("Amigo eliminado correctamente"), 200
        else:
            return jsonify("No se ha podido eliminar al amigo"), 404
@app.route('/search_user/<username>', methods=['GET'])
def search_user(username):
    user_with_username = Users.query.filter_by(username=username).first()
    if user_with_username:
        return jsonify(user_with_username.to_dict()), 200
    else:
        return jsonify({'error': f'User with username "{username}" not found'}), 404
if __name__ == "__main__":
    app.run(debug=True, host="0.0.0.0", port=int(os.environ.get("PORT", 8080)))