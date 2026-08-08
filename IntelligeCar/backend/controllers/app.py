import os

from dotenv import load_dotenv
from flask import Flask
from flask_sqlalchemy import SQLAlchemy


load_dotenv()

db = SQLAlchemy()


def create_app():

    app = Flask(__name__)

    app.config['SQLALCHEMY_DATABASE_URI'] = os.getenv(
        'DATABASE_URL'
    )

    app.config['SQLALCHEMY_TRACK_MODIFICATIONS'] = False

    db.init_app(app)

    # ==========================================
    # IMPORTAÇÃO DOS CONTROLLERS
    # ==========================================

    from controllers.user_controller import user_blueprint

    from controllers.veiculo_controller import veiculo_blueprint

    from controllers.manutencao_controller import manutencao_blueprint

    from controllers.documento_controller import documento_blueprint

    # ==========================================
    # REGISTRO DAS ROTAS
    # ==========================================

    app.register_blueprint(
        user_blueprint,
        url_prefix='/api'
    )

    app.register_blueprint(
        veiculo_blueprint,
        url_prefix='/api'
    )

    app.register_blueprint(
        manutencao_blueprint,
        url_prefix='/api'
    )

    app.register_blueprint(
        documento_blueprint,
        url_prefix='/api'
    )

    # ==========================================
    # ROTA INICIAL
    # ==========================================

    @app.route('/')
    def home():

        return {
            "message": "API do Intelligence Car funcionando!"
        }

    return app


if __name__ == '__main__':

    app = create_app()

    app.run(
        debug=True
    )