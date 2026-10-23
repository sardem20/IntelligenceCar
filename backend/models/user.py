from werkzeug.security import generate_password_hash, check_password_hash
from extensions import db

class Usuario(db.Model):
    __tablename__ = "usuarios"

    id = db.Column(db.Integer, primary_key=True, autoincrement=True)
    nome = db.Column(db.String(100), nullable=False)
    email = db.Column(db.String(100), nullable=False, unique=True)
    telefone = db.Column(db.String(20), nullable=True)
    senha_hash = db.Column(db.String(255), nullable=True)

    veiculos = db.relationship(
        "Veiculo",
        backref="proprietario",
        lazy=True,
        cascade="all, delete-orphan"
    )

    @classmethod
    def criar(cls, nome, email, telefone, senha):
        usuario = cls(nome=nome, email=email, telefone=telefone)
        usuario.definir_senha(senha)  # Agora o self.senha_hash é preenchido corretamente
        db.session.add(usuario)
        db.session.commit()
        return usuario

    @classmethod
    def listar(cls):
        return cls.query.all()

    @classmethod
    def buscar_por_id(cls, user_id):
        return db.session.get(cls, user_id)

    @classmethod
    def buscar_por_email(cls, email):
        return cls.query.filter_by(email=email).first()

    def definir_senha(self, senha):
        self.senha_hash = generate_password_hash(senha)

    def verificar_senha(self, senha):
        return bool(self.senha_hash) and check_password_hash(self.senha_hash, senha)

    def atualizar(self, nome=None, email=None, telefone=None, nova_senha=None):
        if nome is not None:
            self.nome = nome
        if email is not None:
            self.email = email
        if telefone is not None:
            self.telefone = telefone
        if nova_senha is not None:
            self.definir_senha(nova_senha)
        db.session.commit()
        return self

    def deletar(self):
        db.session.delete(self)
        db.session.commit()

    def to_dict(self):
        # A senha (nem o hash) NUNCA sai na API.
        return {
            "id": self.id,
            "nome": self.nome,
            "email": self.email,
            "telefone": self.telefone,
        }
