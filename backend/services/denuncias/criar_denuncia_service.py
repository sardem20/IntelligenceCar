from models.denuncia import Denuncia
from models.user import Usuario
from models.veiculo import Veiculo
from services.denuncias.validacao import normalizar_placa


class CriarDenunciaService:
    def execute(self, usuario_id, placa, tipo, descricao, veiculo_id=None):
        if not Usuario.buscar_por_id(usuario_id):
            raise ValueError("Usuário não encontrado.")
        if veiculo_id is not None and not Veiculo.buscar_por_id(veiculo_id):
            raise ValueError("Veículo não encontrado.")
        placa = normalizar_placa(placa)
        if tipo not in Denuncia.TIPOS:
            raise ValueError(f"Tipo inválido. Use um destes: {', '.join(Denuncia.TIPOS)}.")
        if not descricao or len(descricao.strip()) < 20:
            raise ValueError("Descrição é obrigatória (mínimo de 20 caracteres).")
        return Denuncia.criar(usuario_id, placa, tipo, descricao.strip(), veiculo_id)
