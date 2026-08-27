# IntelligenceCar

Frontend desenvolvido em Flutter para consumir a API do IntelligenceCar.

## Como executar

1. Instale o Flutter.
2. Entre na pasta `frontend`.
3. Execute `flutter pub get`.
4. Confira o endereço da API em `lib/services/api_service.dart`.
5. Execute `flutter run`.

Para Android Emulator, a API local normalmente deve ser acessada por `10.0.2.2:5000`.
Para iOS Simulator ou execução em desktop, use `127.0.0.1:5000`.
Em um celular físico, use o IP da máquina que está executando o backend.

## Backend

Entre na pasta `backend`, configure o arquivo `.env` a partir de `.env.example`, instale as dependências e execute `python app.py`.

O banco deve ser criado usando `database/create_database.sql`.
