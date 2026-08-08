from sqlalchemy import text

from app import db
from models.manutencao import Manutencao


class ManutencaoRepository:

    @staticmethod
    def save(manutencao):

        db.session.add(manutencao)

        db.session.commit()

        return manutencao

    @staticmethod
    def get_all():

        return Manutencao.query.all()

    @staticmethod
    def get_by_id(manutencao_id):

        return db.session.get(
            Manutencao,
            manutencao_id
        )

    @staticmethod
    def delete(manutencao):

        db.session.delete(manutencao)

        db.session.commit()

    @staticmethod
    def historico_por_veiculo(
        veiculo_id
    ):

        sql = text(
            "CALL historico_manutencoes("
            ":veiculo_id)"
        )

        resultado = db.session.execute(
            sql,
            {
                "veiculo_id": veiculo_id
            }
        )

        return resultado.mappings().all()