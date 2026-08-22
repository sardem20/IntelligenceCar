from repositories.documento_repository import (
    DocumentoRepository
)


class DocumentosProximosVencimentoService:

    def execute(self):

        resultado = (
            DocumentoRepository
            .proximos_vencimentos()
        )

        return [
            dict(item)
            for item in resultado
        ]