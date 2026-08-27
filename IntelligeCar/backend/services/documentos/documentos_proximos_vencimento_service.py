from repositories.documento_repository import DocumentoRepository

class DocumentosProximosVencimentoService:
    def execute(self):
        return [dict(item) for item in DocumentoRepository.proximos_vencimentos()]
