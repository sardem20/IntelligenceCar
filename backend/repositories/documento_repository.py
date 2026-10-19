from sqlalchemy import text
from app import db

class DocumentoRepository:
    @staticmethod
    def proximos_vencimentos():
        resultado = db.session.execute(text("CALL documentos_proximos_vencimento()"))
        return resultado.mappings().all()
