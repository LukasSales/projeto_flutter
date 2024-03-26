import 'package:flutter_projeto_live/widgets/backgroundFiltro.widgets.dart';
import 'package:flutter_projeto_live/widgets/backgroundImagem.widgets.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:file_picker/file_picker.dart';
import 'dart:convert';
import 'dart:io';

class Upload {
  final String id;
  final String nomeUpload;
  final String url;
  final List<int> arquivo;
  final String createdAt;
  final String updatedAt;

  Upload({
    required this.id,
    required this.nomeUpload,
    required this.url,
    required this.arquivo,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Upload.fromJson(Map<String, dynamic> json) {
    return Upload(
      id: json['id'],
      nomeUpload: json['nome_upload'],
      url: json['url'],
      arquivo: (json['arquivo']['data'] as List<dynamic>).cast<int>(),
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }
}

class TelaPerfil extends StatefulWidget {
  const TelaPerfil({Key? key}) : super(key: key);

  @override
  _TelaPerfilState createState() => _TelaPerfilState();
}

class _TelaPerfilState extends State<TelaPerfil> {
  List<Upload> uploads = [];
  List<File> arquivosSelecionados = [];

  @override
  void initState() {
    super.initState();
    fetchUploads();
  }

  void fetchUploads() async {
    var headers = {
      'Authorization': 'Bearer TOKEN',
      'User-Agent': 'Apidog/1.0.0 (https://apidog.com)',
      'Content-Type': 'application/json'
    };

    var uri = Uri.parse(
        'https://www.welldone-dev.tech:3000/api/v1/uploads/?page=1&limit=10');
    var response = await http.get(uri, headers: headers);

    if (response.statusCode == 200) {
      var jsonResponse = jsonDecode(response.body);
      List<Upload> fetchedUploads = [];

      for (var data in jsonResponse['data']) {
        fetchedUploads.add(Upload.fromJson(data));
      }

      setState(() {
        uploads = fetchedUploads;
      });
    } else {
      print(response.reasonPhrase);
    }
  }

  Future<bool> solicitarPermissao() async {
    var status = await Permission.storage.status;
    if (!status.isGranted) {
      status = await Permission.storage.request();
    }
    return status.isGranted;
  }

  Future<void> adicionarArquivo() async {
    bool permissaoConcedida = await solicitarPermissao();
    if (permissaoConcedida) {
      File? arquivoSelecionado = await selecionarArquivoDoDispositivo();
      if (arquivoSelecionado != null) {
        setState(() {
          arquivosSelecionados.add(arquivoSelecionado);
        });
      }
    } else {
      print('Permissão negada.');
    }
  }

  Future<File?> selecionarArquivoDoDispositivo() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();

    if (result != null) {
      File arquivoSelecionado = File(result.files.single.path!);
      return arquivoSelecionado;
    } else {
      return null;
    }
  }

  Future<void> _enviarArquivos() async {
    var headers = {
      'Authorization': 'Bearer TOKEN',
      'User-Agent': 'Apidog/1.0.0 (https://apidog.com)',
    };

    var request = http.MultipartRequest(
      'POST',
      Uri.parse('https://www.welldone-dev.tech:3000/api/v1/uploads/'),
    );

    // Adicionando arquivos ao corpo da requisição
    for (var arquivo in arquivosSelecionados) {
      request.files.add(await http.MultipartFile.fromPath(
        'arquivo',
        arquivo.path,
      ));
    }

    // Adicionando headers à requisição
    request.headers.addAll(headers);

    var streamedResponse = await request.send();

    if (streamedResponse.statusCode == 200) {
      print(await streamedResponse.stream.bytesToString());
      // Limpar a lista após o envio bem-sucedido
      setState(() {
        arquivosSelecionados.clear();
      });
    } else {
      print(streamedResponse.reasonPhrase);
    }
  }

  Future<void> deletarArquivoServidor(String uploadId) async {
    var headers = {
      'Authorization': 'Bearer TOKEN',
      'User-Agent': 'Apidog/1.0.0 (https://apidog.com)',
      'Content-Type': 'application/json'
    };

    var uri = Uri.parse(
        'https://www.welldone-dev.tech:3000/api/v1/uploads/?id=$uploadId');

    var request = http.Request('DELETE', uri);
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      print(await response.stream.bytesToString());
    } else {
      print(response.reasonPhrase);
    }
  }

  Future<void> realizarDownload(String uploadId) async {
    var headers = {
      'Authorization': 'Bearer TOKEN',
      'User-Agent': 'Apidog/1.0.0 (https://apidog.com)',
      'Content-Type': 'application/json'
    };

    var uri = Uri.parse(
        'https://www.welldone-dev.tech:3000/api/v1/uploads/$uploadId/download');

    var request = http.Request('GET', uri);
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      print('Download concluído');
    } else {
      print('Falha ao baixar o arquivo: ${response.reasonPhrase}');
    }
  }

  Future<void> removerArquivo(int index) async {
    setState(() {
      arquivosSelecionados.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.only(left: 16, top: 10),
          child: Image.asset(
            "assets/🦆 emoji _waving hand_.png",
            width: 32,
            height: 32,
          ),
        ),
        title: const Row(
          children: [
            Expanded(
              child: Text(
                'Bem-vindo (a)',
                style: TextStyle(
                  fontFamily: 'Roboto',
                  fontWeight: FontWeight.w700,
                  fontSize: 18,
                  color: Colors.black,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.account_circle),
            onPressed: () {
              print("Ir para perfil");
              // Ser redirecionado ao perfil
            },
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              Navigator.pushReplacementNamed(context, 'tela_01');
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          // Background com imagem de fundo
          const backgroundImagem(),
          // Filtro opaco com degradê
          const Positioned.fill(
            child: backgroundFiltro(),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 0),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  color: Colors.transparent,
                  child: Stack(
                    alignment: Alignment.topRight,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Expanded(
                            child: Container(
                              margin: const EdgeInsets.symmetric(vertical: 8),
                              color: Colors.white,
                              child: Stack(
                                children: [
                                  Positioned(
                                    top: 120,
                                    left: 15,
                                    child: Container(
                                      width: 160,
                                      height: 160,
                                      decoration: BoxDecoration(
                                        color: const Color(0xFFF8FDFF),
                                        borderRadius: BorderRadius.circular(20),
                                        border: Border.all(
                                            width: 1,
                                            color: const Color(0xFF838383)),
                                        boxShadow: [
                                          BoxShadow(
                                            color: const Color(0xFF000000)
                                                .withOpacity(0.25),
                                            offset: const Offset(0, 4),
                                            blurRadius: 4,
                                            spreadRadius: 0,
                                          ),
                                        ],
                                      ),
                                      padding: const EdgeInsets.all(8),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Container(
                                            width: 80,
                                            height: 50,
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                            ),
                                            child: IconButton(
                                              iconSize: 40,
                                              icon: const Icon(Icons.add),
                                              onPressed: adicionarArquivo,
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 10,
                                          ),
                                          const Text(
                                            'Clique aqui para anexar um arquivo',
                                            style: TextStyle(
                                              fontFamily: 'Roboto',
                                              fontWeight: FontWeight.w400,
                                              fontSize: 16,
                                              height: 20 / 16,
                                              color: Color(0xFF303030),
                                            ),
                                            textAlign: TextAlign.center,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.stretch,
                                    children: [
                                      const SizedBox(height: 300),
                                      const Text(
                                        'Itens anexados',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      Expanded(
                                        child: ListView.builder(
                                          itemCount:
                                              arquivosSelecionados.length,
                                          itemBuilder: (context, index) {
                                            final file =
                                                arquivosSelecionados[index];
                                            return Row(
                                              children: [
                                                const Icon(Icons.attach_file),
                                                const SizedBox(
                                                    width:
                                                        8), // Adiciona um espaço entre o ícone e o texto
                                                Expanded(
                                                  child: Text(
                                                    file.path.split('/').last,
                                                    maxLines:
                                                        1, // Define o máximo de linhas para 1
                                                    overflow: TextOverflow
                                                        .ellipsis, // Define o overflow para ellipsis
                                                  ),
                                                ),
                                                IconButton(
                                                  icon:
                                                      const Icon(Icons.delete),
                                                  onPressed: () =>
                                                      removerArquivo(index),
                                                ),
                                              ],
                                            );
                                          },
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(10),
                                        child: ElevatedButton(
                                          onPressed: _enviarArquivos,
                                          child: const Text('Enviar'),
                                        ),
                                      ),
                                      const SizedBox(height: 16),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Expanded(
                            child: Container(
                              margin: const EdgeInsets.symmetric(vertical: 8),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                border: Border(
                                  left: BorderSide(
                                    color: Colors.grey[500]!,
                                    width: 1,
                                  ),
                                ),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Padding(
                                    padding: EdgeInsets.only(left: 15, top: 8),
                                    child: Text(
                                      'Itens anexados anteriormente',
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  // Lista de arquivos anexados
                                  Expanded(
                                    child: SingleChildScrollView(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.stretch,
                                        children: [
                                          for (var upload in uploads)
                                            Container(
                                              margin: const EdgeInsets
                                                  .symmetric(
                                                  vertical: 8,
                                                  horizontal:
                                                      16), // Adicionando margem horizontal
                                              padding: const EdgeInsets.all(
                                                  8), // Adicionando preenchimento interno
                                              decoration: BoxDecoration(
                                                color: Colors.grey[200],
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                              ),
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment
                                                    .spaceBetween, // Alterado para MainAxisAlignment.spaceBetween
                                                children: [
                                                  Expanded(
                                                    child: Text(
                                                      upload.nomeUpload,
                                                      maxLines:
                                                          1, // Permitindo apenas uma linha para o nome
                                                      overflow: TextOverflow
                                                          .ellipsis, // Adicionando '...' se o texto não couber
                                                      style: const TextStyle(
                                                          fontSize:
                                                              16), // Ajustando o tamanho da fonte
                                                    ),
                                                  ),
                                                  IconButton(
                                                    icon: const Icon(
                                                        Icons.delete),
                                                    onPressed: () {
                                                      deletarArquivoServidor(
                                                          upload.id);
                                                    },
                                                  ),
                                                  IconButton(
                                                    icon: const Icon(
                                                        Icons.download),
                                                    onPressed: () {
                                                      realizarDownload(
                                                          upload.id);
                                                    },
                                                  ),
                                                ],
                                              ),
                                            ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
