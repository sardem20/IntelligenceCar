from app import db


class Documento(db.Model):

    __tablename__ = 'documentos'

    id = db.Column(
        db.Integer,
        primary_key=True,
        autoincrement=True
    )

    veiculo_id = db.Column(
        db.Integer,
        db.ForeignKey('veiculos.id'),
        nullable=False
    )

    tipo = db.Column(
        db.String(100),
        nullable=False
    )

    data_emissao = db.Column(
        db.Date
    )

    data_validade = db.Column(
        db.Date,
        nullable=False
    )

    def to_dict(self):

        return {
            "id": self.id,
            "veiculo_id": self.veiculo_id,
            "tipo": self.tipo,
            "data_emissao": (
                self.data_emissao.isoformat()
                if self.data_emissao
                else None
            ),
            "data_validade": (
                self.data_validade.isoformat()
                if self.data_validade
                else None
            )
        }