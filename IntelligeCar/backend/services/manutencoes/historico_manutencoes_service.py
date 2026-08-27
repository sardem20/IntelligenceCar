from repositories.manutencao_repository import ManutencaoRepository

class HistoricoManutencoesService:
    def execute(self, veiculo_id):
        return [dict(item) for item in ManutencaoRepository.historico_por_veiculo(veiculo_id)]
