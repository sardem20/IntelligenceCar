from models.denuncia import Denuncia


class AtualizarDenunciaService:
    def execute(self, denuncia_id, tipo=None, descricao=None, status=None):
        item = Denuncia.buscar_por_id(denuncia_id)
        if not item:
            raise LookupError("Denúncia não encontrada.")
        if tipo is not None and tipo not in Denuncia.TIPOS:
            raise ValueError(f"Tipo inválido. Use um destes: {', '.join(Denuncia.TIPOS)}.")
        if status is not None and status not in Denuncia.STATUS:
            raise ValueError(f"Status inválido. Use um destes: {', '.join(Denuncia.STATUS)}.")
        if descricao is not None and len(descricao.strip()) < 20:
            raise ValueError("Descrição deve ter no mínimo 20 caracteres.")
        descricao = descricao.strip() if descricao is not None else None
        return item.atualizar(tipo, descricao, status)
