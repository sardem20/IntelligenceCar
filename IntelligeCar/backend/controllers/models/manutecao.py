from app import db


class Manutencao(db.Model):

    __tablename__ = 'manutencoes'

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

    descricao = db.Column(
        db.Text
    )

    data_manutencao = db.Column(
        db.Date,
        nullable=False
    )

    quilometragem = db.Column(
        db.Integer,
        nullable=False
    )

    valor = db.Column(
        db.Numeric(10, 2),
        default=0
    )

    def to_dict(self):

        return {
            "id": self.id,
            "veiculo_id": self.veiculo_id,
            "tipo": self.tipo,
            "descricao": self.descricao,
            "data_manutencao": (
                self.data_manutencao.isoformat()
                if self.data_manutencao
                else None
            ),
            "quilometragem": self.quilometragem,
            "valor": (
                float(self.valor)
                if self.valor is not None
                else 0
            )
        }