from sqlalchemy import text

from app import db


class DocumentoRepository:

    @staticmethod
    def proximos_vencimentos():

        sql = text(
            "CALL documentos_proximos_vencimento()"
        )

        resultado = db.session.execute(sql)

        return resultado.mappings().all()