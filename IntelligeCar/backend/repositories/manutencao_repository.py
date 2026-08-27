from sqlalchemy import text
from app import db

class ManutencaoRepository:
    @staticmethod
    def historico_por_veiculo(veiculo_id):
        resultado = db.session.execute(
            text("CALL historico_manutencoes(:veiculo_id)"),
            {"veiculo_id": veiculo_id}
        )
        return resultado.mappings().all()
