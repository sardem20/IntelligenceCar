from models.denuncia import Denuncia
from repositories.denuncia_repository import DenunciaRepository
from services.denuncias.validacao import normalizar_placa


class BuscarDenunciasService:
    """Busca avançada com filtros (tipo, status, placa) e ordenação, via procedure."""

    def execute(self, tipo=None, status=None, placa=None, ordem="data_desc"):
        if tipo and tipo not in Denuncia.TIPOS:
            raise ValueError("Tipo inválido.")
        if status and status not in Denuncia.STATUS:
            raise ValueError("Status inválido.")
        if ordem not in ("data_asc", "data_desc"):
            raise ValueError("Ordem inválida. Use data_asc ou data_desc.")
        placa = normalizar_placa(placa) if placa else None
        itens = DenunciaRepository.buscar_denuncias(tipo, status, placa, ordem)
        return [self._serializar(item) for item in itens]

    @staticmethod
    def _serializar(item):
        item = dict(item)
        if item.get("data_criacao"):
            item["data_criacao"] = item["data_criacao"].isoformat()
        return item
