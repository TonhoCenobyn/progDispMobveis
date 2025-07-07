import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';

import '../../../../core/ui/redesign/theme/app_colors.dart';
import '../models/gts_model.dart';
import 'gts_historico_controller.dart';
// Importe o controller e o GtsModel do seu projeto
// import 'gts_historico_controller.dart';
// import 'path/to/your/gts_model.dart';

class GtsHistoricoPage extends StatefulWidget {
  const GtsHistoricoPage({Key? key}) : super(key: key);

  @override
  State<GtsHistoricoPage> createState() => _GtsHistoricoPageState();
}

class _GtsHistoricoPageState extends State<GtsHistoricoPage> {
  final GtsHistoricoController controller = Modular.get<GtsHistoricoController>();
  late final File? pdfFile;
  late final PDFViewController? pdfViewController;

  @override
  void initState() {
    super.initState();
    controller.carregarGtsList();
    _loadPdf();
  }

  _loadPdf() async {
    //controller.loading = true;
    try {
      //pdfFile = await controller.getPdfFile(widget.gts);
    } finally {
      //controller.loading = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: Column(
        children: [
          // Header com título do histórico
          // Mensagem de erro (se houver)
          ValueListenableBuilder<String?>(
            valueListenable: controller.errorMessage,
            builder: (context, errorMsg, child) {
              if (errorMsg != null) {
                return Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  color: Colors.red[50],
                  child: Row(
                    children: [
                      Icon(Icons.error, color: Colors.red[700]),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          errorMsg,
                          style: TextStyle(color: Colors.red[700]),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () => controller.limparErro(),
                      ),
                    ],
                  ),
                );
              }
              return const SizedBox.shrink();
            },
          ),
          // Lista de GTSs
          Expanded(
            child: ValueListenableBuilder<List<GtsModel>>(
              valueListenable: controller.gtsListNotifier,
              builder: (context, gtsList, child) {
                return ValueListenableBuilder<bool>(
                  valueListenable: controller.isLoading,
                  builder: (context, isLoading, child) {
                    if (isLoading) {
                      return const Center(
                        child: CircularProgressIndicator(
                          color: Color(0xFF4CAF50),
                        ),
                      );
                    }

                    if (gtsList.isEmpty) {
                      return const Center(
                        child: Text(
                          'Nenhuma GTS encontrada',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey,
                          ),
                        ),
                      );
                    }

                    return RefreshIndicator(
                      onRefresh: controller.atualizarGtsList,
                      child: ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: gtsList.length,
                        itemBuilder: (context, index) {
                          final gts = gtsList[index];
                          return GtsHistoricoCard(
                            gts: gts,
                            controller: controller,
                            pdfViewController: pdfViewController,
                            pdfFile: pdfFile
                          );
                        },
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class GtsHistoricoCard extends StatelessWidget {
  final GtsModel gts;
  final GtsHistoricoController controller;
  final File? pdfFile;
  PDFViewController? pdfViewController;

  GtsHistoricoCard({
    Key? key,
    required this.gts,
    required this.controller,
    required this.pdfViewController,
    required this.pdfFile
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 3,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Linha do número da GTS
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    'Número: ${controller.getGtsNumero(gts)}',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                    overflow: TextOverflow.ellipsis, // Evita overflow
                  ),
                ),
                Row(
                  children: [
                    // Ícone de visualizar
                    GestureDetector(
                      onTap: () =>
                          PDFView(
                            filePath: pdfFile!.path,
                            fitPolicy: FitPolicy.WIDTH,
                            enableSwipe: true,
                            swipeHorizontal: true,
                            fitEachPage: true,
                            backgroundColor: AppColors.neutral090,
                            defaultPage: 0,
                            onViewCreated: (PDFViewController viewController) {
                              pdfViewController = viewController;
                              pdfViewController!.setPage(0);
                            },
                            onPageChanged: (int? currentPage, int? totalPages) {
                              currentPage ??= -1;
                            },
                          ),
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: const Color(0xFF4CAF50),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: const Icon(
                          Icons.visibility,
                          color: Colors.white,
                          size: 16,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    // Ícone de deletar
                    GestureDetector(
                      onTap: () => _mostrarOpcoesDeletar(context),
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFF5722),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: const Icon(
                          Icons.delete,
                          color: Colors.white,
                          size: 16,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 8),
            // Informações da GTS
            _buildInfoRow('Origem:', controller.getGtsOrigem(gts)),
            const SizedBox(height: 4),
            _buildInfoRow('Destino:', controller.getGtsDestino(gts)),
            const SizedBox(height: 4),
            _buildInfoRow('Data de Emissão:', controller.getGtsDataEmissao(gts)),
            if (gts.descricao != null && gts.descricao!.isNotEmpty) ...[
              const SizedBox(height: 4),
              _buildInfoRow('Descrição:', gts.descricao!),
            ],
            if (gts.transporte != null && gts.transporte!.isNotEmpty) ...[
              const SizedBox(height: 4),
              _buildInfoRow('Transporte:', gts.transporte!),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            color: Colors.black87,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(
              fontSize: 14,
              color: Colors.black54,
            ),
          ),
        ),
      ],
    );
  }

  void _visualizarGts(BuildContext context) {
    // Implementar navegação para tela de visualização
    // Modular.to.pushNamed('/gts/visualizar', arguments: gts);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Visualizar GTS ${controller.getGtsNumero(gts)}')),
    );
  }

  void _mostrarOpcoesDeletar(BuildContext context) {
    // Implementar funcionalidade de deletar se necessário
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Deletar GTS ${controller.getGtsNumero(gts)}')),
    );
  }
}

