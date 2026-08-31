from models.documento import Documento

class DeletarDocumentoService:
    def execute(self, documento_id):
        item = Documento.buscar_por_id(documento_id)
        if not item:
            raise ValueError("Documento não encontrado.")
        item.deletar()
        return True
