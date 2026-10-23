import 'package:flutter/material.dart';
import './login_page.dart';

class CadastroPage extends StatelessWidget {
  const CadastroPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFF203F68),
        foregroundColor: Colors.white,
        title: const Text(
          'CADASTRO DO USUÁRIO',
          style: TextStyle(fontSize: 14),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          children: [
            const TextField(
                      decoration: InputDecoration(
                        hintText: 'NOME',
                        hintStyle: TextStyle(
                          color: Color(0xFF4D86E8),
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      )
            ),
            const TextField(
                      decoration: InputDecoration(
                        hintText: 'E-MAIL',
                        hintStyle: TextStyle(
                          color: Color(0xFF4D86E8),
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      )
            ),
            const TextField(
                      decoration: InputDecoration(
                        hintText: 'TELEFONE',
                        hintStyle: TextStyle(
                          color: Color(0xFF4D86E8),
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      )
            ),
            const TextField(
                      decoration: InputDecoration(
                        hintText: 'SENHA',
                        hintStyle: TextStyle(
                          color: Color(0xFF4D86E8),
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      )
            ),

            const SizedBox(height: 25),

            SizedBox(
              width: 230,
              height: 45,
              child: ElevatedButton(
                onPressed: () {
                   Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => LoginPage()),
                        );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF5287CF),
                  foregroundColor: Colors.white,
                  side: const BorderSide(
                    color: Colors.black,
                    width: 1.5,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: const Text(
                  'CADASTRAR',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }


  Widget campo(String titulo, String exemplo) {
    return Container(
      width: double.infinity,
      height: 77,
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.symmetric(
        horizontal: 14,
        vertical: 3,
      ),
      decoration: BoxDecoration(
        color: const Color(0xFFD6D6D6),
        border: Border.all(
          color: const Color(0xFF203F68),
          width: 2.5,
        ),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            titulo,
            style: const TextStyle(
              fontSize: 19,
              color: Colors.black,
            ),
          ),
          Center(
            child: Text(
              exemplo,
              style: const TextStyle(
                fontSize: 20,
                color: Colors.black,
              ),
            ),
          ),
        ],
      ),
    );
  }
}