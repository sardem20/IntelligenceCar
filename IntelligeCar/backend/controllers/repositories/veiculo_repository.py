from sqlalchemy import text

from app import db
from models.veiculo import Veiculo


class VeiculoRepository:

    @staticmethod
    def save(veiculo):

        db.session.add(veiculo)

        db.session.commit()

        return veiculo

    @staticmethod
    def get_all():

        return Veiculo.query.all()

    @staticmethod
    def get_by_id(veiculo_id):

        return db.session.get(
            Veiculo,
            veiculo_id
        )

    @staticmethod
    def get_by_placa(placa):

        return Veiculo.query.filter_by(
            placa=placa
        ).first()

    @staticmethod
    def delete(veiculo):

        db.session.delete(veiculo)

        db.session.commit()

    @staticmethod
    def buscar_veiculos(
        marca=None,
        modelo=None,
        ordem='modelo_asc'
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