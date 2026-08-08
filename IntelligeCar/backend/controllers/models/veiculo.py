from app import db


class Veiculo(db.Model):

    __tablename__ = 'veiculos'

    id = db.Column(
        db.Integer,
        primary_key=True,
        autoincrement=True
    )

    usuario_id = db.Column(
        db.Integer,
        db.ForeignKey('usuarios.id'),
        nullable=False
    )

    marca = db.Column(
        db.String(50),
        nullable=False
    )

    modelo = db.Column(
        db.String(100),
        nullable=False
    )

    ano = db.Column(
        db.Integer,
        nullable=False
    )

    placa = db.Column(
        db.String(10),
        nullable=False,
        unique=True
    )

    quilometragem = db.Column(
        db.Integer,
        nullable=False,
        default=0
    )

    def to_dict(self):

        return {
            "id": self.id,
            "usuario_id": self.usuario_id,
            "marca": self.marca,
            "modelo": self.modelo,
            "ano": self.ano,
            "placa": self.placa,
            "quilometragem": self.quilometragem
        }