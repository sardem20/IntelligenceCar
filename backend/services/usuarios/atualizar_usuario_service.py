from models.user import Usuario
from services.usuarios.validacao import validar_email, normalizar_telefone, validar_senha

class AtualizarUsuarioService:
    def execute(self, user_id, nome=None, email=None, telefone=None,
                senha_atual=None, nova_senha=None):
        usuario = Usuario.buscar_por_id(user_id)
        if not usuario:
            raise LookupError("Usuário não encontrado.")
        if nome is not None and not nome.strip():
            raise ValueError("Nome é obrigatório.")
        if email is not None:
            email = validar_email(email)
            existente = Usuario.buscar_por_email(email)
            if existente and existente.id != usuario.id:
                raise ValueError("Este e-mail já está cadastrado.")
        if telefone is not None:
            telefone = normalizar_telefone(telefone)
        if nova_senha is not None:
            validar_senha(nova_senha)
            # Trocar a senha exige confirmar a senha atual
            # (usuários antigos, ainda sem senha, podem definir a primeira sem informar a atual).
            if usuario.senha_hash and not usuario.verificar_senha(senha_atual or ""):
                raise ValueError("Senha atual incorreta.")
        return usuario.atualizar(
            nome=nome.strip() if nome is not None else None,
            email=email,
            telefone=telefone,
            nova_senha=nova_senha,
        )
