from app import db
from models.user import Usuario


class UserRepository:

    @staticmethod
    def save(usuario):

        db.session.add(usuario)
        db.session.commit()

        return usuario

    @staticmethod
    def get_all():

        return Usuario.query.all()

    @staticmethod
    def get_by_id(user_id):

        return db.session.get(
            Usuario,
            user_id
        )

    @staticmethod
    def get_by_email(email):

        return Usuario.query.filter_by(
            email=email
        ).first()

    @staticmethod
    def delete(usuario):

        db.session.delete(usuario)

        db.session.commit()