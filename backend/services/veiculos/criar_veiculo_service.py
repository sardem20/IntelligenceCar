from models.veiculo import Veiculo
from models.user import Usuario

class CriarVeiculoService:
    def execute(self, usuario_id, marca, modelo, ano, placa, quilometragem=0):
        if not Usuario.buscar_por_id(usuario_id):
            raise ValueError("Usuário não encontrado.")
        if not marca or not marca.strip():
            raise ValueError("Marca é obrigatória.")
        if not modelo or not modelo.strip():
            raise ValueError("Modelo é obrigatório.")
        if not placa or not placa.strip():
            raise ValueError("Placa é obrigatória.")
        if not isinstance(ano, int):
            raise ValueError("Ano inválido.")
        return Veiculo.criar(
            usuario_id, marca.strip(), modelo.strip(), ano,
            placa.strip().upper(), quilometragem or 0
        )
