from sqlalchemy import text
from extensions import db


class DenunciaRepository:
    @staticmethod
    def buscar_denuncias(tipo=None, status=None, placa=None, ordem="data_desc"):
        resultado = db.session.execute(
            text("CALL buscar_denuncias(:tipo, :status, :placa, :ordem)"),
            {
                "tipo": tipo or None,
                "status": status or None,
                "placa": placa or None,
                "ordem": ordem,
            },
        )
        return resultado.mappings().all()

    @staticmethod
    def consultar_placa(placa):
        resultado = db.session.execute(
            text("CALL consultar_placa_denuncias(:placa)"),
            {"placa": placa},
        )
        return resultado.mappings().first()
