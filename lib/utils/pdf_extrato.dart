import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import '../models/shop.dart';

Future<void> gerarExtratoPDF(
  List<Shop> lista,
  String? pessoaFiltro,
) async {
  final pdf = pw.Document();

  final totais = calcularTotalPorPessoa(lista); // ✅ FORA DO BUILD

  pdf.addPage(
    pw.Page(
      pageFormat: PdfPageFormat.a4,
      build: (context) {
        return pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Text(
              'Extrato de Gastos',
              style: pw.TextStyle(
                fontSize: 24,
                fontWeight: pw.FontWeight.bold,
              ),
            ),

            pw.SizedBox(height: 8),

            pw.Text(
              pessoaFiltro == null
                  ? 'Pessoa: Todas'
                  : 'Pessoa: $pessoaFiltro',
              style: const pw.TextStyle(fontSize: 14),
            ),

            pw.Divider(),

            pw.SizedBox(height: 12),

            pw.Text(
              'Total por pessoa',
              style: pw.TextStyle(
                fontSize: 16,
                fontWeight: pw.FontWeight.bold,
              ),
            ),

            pw.SizedBox(height: 6),

            pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: totais.entries.map(
                (e) => pw.Text(
                  '${e.key}: R\$ ${e.value.toStringAsFixed(2)}',
                ),
              ).toList(),
            ),

            pw.SizedBox(height: 12),

            pw.Table.fromTextArray(
              headers: ['Valor', 'Banco', 'Pessoa', 'Data'],
              data: lista.map((shop) {
                return [
                  'R\$ ${shop.title}',
                  shop.banco,
                  shop.pessoa,
                  '${shop.dateTime.day}/${shop.dateTime.month}/${shop.dateTime.year}',
                ];
              }).toList(),
            ),
          ],
        );
      },
    ),
  );

  await Printing.layoutPdf(
    onLayout: (format) async => pdf.save(),
  );
}

Map<String, double> calcularTotalPorPessoa(List<Shop> lista) {
  final Map<String, double> totais = {};

  for (final shop in lista) {
    final valor = double.tryParse(shop.title) ?? 0;

    totais.update(
      shop.pessoa,
      (valorAtual) => valorAtual + valor,
      ifAbsent: () => valor,
    );
  }

  return totais;
}

