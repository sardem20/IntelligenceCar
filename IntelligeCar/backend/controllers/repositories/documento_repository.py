from sqlalchemy import text

from app import db
from models.documento import Documento


class DocumentoRepository:

    @staticmethod
    def save(documento):

        db.session.add(documento)

        db.session.commit()

        return documento

    @staticmethod
    def get_all():

        return Documento.query.all()

    @staticmethod
    def get_by_id(documento_id):

        return db.session.get(
            Documento,
            documento_id
        )

    @staticmethod
    def delete(documento):

        db.session.delete(documento)

        db.session.commit()

    @staticmethod
    def proximos_vencimentos():

        sql = text(
            "CALL documentos_proximos_vencimento()"
        )

        resultado = db.session.execute(
            sql
        )

        return resultado.mappings().all()