from datetime import date
from models.documento import Documento

class AtualizarDocumentoService:
    def execute(self, documento_id, tipo=None, data_emissao=None, data_validade=None):
        item = Documento.buscar_por_id(documento_id)
        if not item:
            raise ValueError("Documento não encontrado.")
        emissao = date.fromisoformat(data_emissao) if data_emissao else None
        validade = date.fromisoformat(data_validade) if data_validade else None
        return item.atualizar(tipo, emissao, validade)
