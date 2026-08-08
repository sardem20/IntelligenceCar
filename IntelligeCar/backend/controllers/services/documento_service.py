from repositories.documento_repository import (
    DocumentoRepository
)


class DocumentoService:

    @staticmethod
    def proximos_vencimentos():

        documentos = (
            DocumentoRepository
            .proximos_vencimentos()
        )

        return [
            dict(documento)
            for documento in documentos
        ]