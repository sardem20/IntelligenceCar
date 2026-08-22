from sqlalchemy import text

from app import db


class VeiculoRepository:

    @staticmethod
    def buscar_veiculos(
        marca=None,
        modelo=None,
        ordem="modelo_asc"
    ):

        sql = text(
            "CALL buscar_veiculos("
            ":marca, :modelo, :ordem)"
        )

        resultado = db.session.execute(
            sql,
            {
                "marca": marca,
                "modelo": modelo,
                "ordem": ordem
            }
        )

        return resultado.mappings().all()