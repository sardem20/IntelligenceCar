from app import db


class Usuario(db.Model):

    __tablename__ = 'usuarios'

    id = db.Column(
        db.Integer,
        primary_key=True,
        autoincrement=True
    )

    nome = db.Column(
        db.String(100),
        nullable=False
    )

    email = db.Column(
        db.String(100),
        nullable=False,
        unique=True
    )

    # Relacionamento com veículos
    veiculos = db.relationship(
        'Veiculo',
        backref='proprietario',
        lazy=True,
        cascade='all, delete-orphan'
    )

    def to_dict(self):

        return {
            "id": self.id,
            "nome": self.nome,
            "email": self.email
        }