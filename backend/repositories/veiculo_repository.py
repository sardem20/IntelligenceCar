from sqlalchemy import text
from app import db

class VeiculoRepository:
    @staticmethod
    def buscar_veiculos(marca=None, modelo=None, ordem="modelo_asc"):
        resultado = db.session.execute(
            text("CALL buscar_veiculos(:marca, :modelo, :ordem)"),
            {"marca": marca or None, "modelo": modelo or None, "ordem": ordem}
        )
        return resultado.mappings().all()
