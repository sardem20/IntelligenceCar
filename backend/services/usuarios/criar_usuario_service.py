from models.user import Usuario
from services.usuarios.validacao import validar_email, normalizar_telefone, validar_senha

class CriarUsuarioService:
    def execute(self, nome, email, telefone, senha):
        if not nome or not nome.strip():
            raise ValueError("Nome é obrigatório.")
        email = validar_email(email)
        telefone = normalizar_telefone(telefone)
        validar_senha(senha)
        if Usuario.buscar_por_email(email):
            raise ValueError("Este e-mail já está cadastrado.")
        return Usuario.criar(nome.strip(), email, telefone, senha)
