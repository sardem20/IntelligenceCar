from datetime import date
from models.documento import Documento
from models.veiculo import Veiculo

class CriarDocumentoService:
    def execute(self, veiculo_id, tipo, data_emissao, data_validade):
        if not Veiculo.buscar_por_id(veiculo_id):
            raise ValueError("Veículo não encontrado.")
        if not tipo or not tipo.strip():
            raise ValueError("Tipo é obrigatório.")
        emissao = date.fromisoformat(data_emissao) if data_emissao else None
        validade = date.fromisoformat(data_validade)
        return Documento.criar(veiculo_id, tipo.strip(), emissao, validade)
