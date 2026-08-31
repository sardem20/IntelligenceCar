from models.manutencao import Manutencao

class ListarManutencoesService:
    def execute(self):
        return [item.to_dict() for item in Manutencao.listar()]
