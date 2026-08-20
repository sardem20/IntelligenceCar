from models.user import Usuario


class CriarUsuarioService:

    def execute(self, nome, email):

        if not nome or not nome.strip():

            raise ValueError(
                "Nome é obrigatório."
            )

        if not email or not email.strip():

            raise ValueError(
                "Email é obrigatório."
            )

        usuario = Usuario.criar(
            nome.strip(),
            email.strip().lower()
        )

        return usuario