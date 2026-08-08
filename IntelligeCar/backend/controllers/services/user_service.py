from models.user import Usuario

from repositories.user_repository import (
    UserRepository
)


class UserService:

    @staticmethod
    def criar_usuario(nome, email):

        if not nome or not nome.strip():

            raise ValueError(
                "Nome é obrigatório."
            )

        if not email or not email.strip():

            raise ValueError(
                "Email é obrigatório."
            )

        nome = nome.strip()
        email = email.strip().lower()

        usuario_existente = (
            UserRepository.get_by_email(email)
        )

        if usuario_existente:

            raise ValueError(
                "Este email já está cadastrado."
            )

        novo_usuario = Usuario(
            nome=nome,
            email=email
        )

        return UserRepository.save(
            novo_usuario
        )

    @staticmethod
    def listar_usuarios():

        usuarios = UserRepository.get_all()

        return [
            usuario.to_dict()
            for usuario in usuarios
        ]

    @staticmethod
    def buscar_por_id(user_id):

        usuario = UserRepository.get_by_id(
            user_id
        )

        if not usuario:

            return None

        return usuario.to_dict()

    @staticmethod
    def atualizar_usuario(
        user_id,
        nome,
        email
    ):

        usuario = UserRepository.get_by_id(
            user_id
        )

        if not usuario:

            raise ValueError(
                "Usuário não encontrado."
            )

        if nome is not None:

            if not nome.strip():

                raise ValueError(
                    "Nome não pode ser vazio."
                )

            usuario.nome = nome.strip()

        if email is not None:

            if not email.strip():

                raise ValueError(
                    "Email não pode ser vazio."
                )

            email = email.strip().lower()

            outro_usuario = (
                UserRepository.get_by_email(
                    email
                )
            )

            if (
                outro_usuario
                and outro_usuario.id != usuario.id
            ):

                raise ValueError(
                    "Este email já está sendo utilizado."
                )

            usuario.email = email

        return UserRepository.save(
            usuario
        )

    @staticmethod
    def deletar_usuario(user_id):

        usuario = UserRepository.get_by_id(
            user_id
        )

        if not usuario:

            raise ValueError(
                "Usuário não encontrado."
            )

        UserRepository.delete(usuario)

        return True