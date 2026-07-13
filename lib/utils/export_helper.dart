import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:excel/excel.dart' as excel;
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import '../../presentation/providers/competition_provider.dart';
import '../../data/models/models.dart';

/// Ütil para exportação de dados
class ExportHelper {
  /// Exporta para PDF
  static Future<void> exportToPdf(
    BuildContext context,
    Competition competition,
  ) async {
    try {
      final pdf = pw.Document();
      final dateFormat = DateFormat('dd/MM/yyyy HH:mm');

      pdf.addPage(
        pw.MultiPage(
          pageFormat: PdfPageFormat.a4,
          build: (pw.Context context) {
            return [
              pw.Text(
                competition.name,
                style: pw.TextStyle(
                  fontSize: 24,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
              pw.SizedBox(height: 8),
              pw.Text(
                'Data: ${dateFormat.format(competition.date)}',
                style: const pw.TextStyle(fontSize: 12),
              ),
              pw.SizedBox(height: 8),
              pw.Text(
                'Participantes: ${competition.participants.length}',
                style: const pw.TextStyle(fontSize: 12),
              ),
              pw.SizedBox(height: 20),
              _buildPdfTable(competition),
              pw.SizedBox(height: 20),
              _buildPdfStatistics(competition),
            ];
          },
        ),
      );

      final output = await getApplicationDocumentsDirectory();
      final file = File(
        '${output.path}/${competition.name}_${DateTime.now().millisecondsSinceEpoch}.pdf',
      );
      await file.writeAsBytes(await pdf.save());

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('PDF exportado: ${file.path}')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao exportar PDF: $e')),
      );
    }
  }

  /// Exporta para Excel
  static Future<void> exportToExcel(
    BuildContext context,
    Competition competition,
  ) async {
    try {
      var excelFile = excel.Excel.createExcel();
      excelFile.rename('Sheet1', 'Resultados');
      var sheet = excelFile['Resultados'];

      // Headers
      sheet.appendRow([
        excel.TextCellValue(competition.name),
      ]);
      sheet.appendRow([
        excel.TextCellValue('Data: ${competition.date}'),
      ]);
      sheet.appendRow([]);

      // Coluna de Participantes
      sheet.appendRow(
        ['Participante'] +
            List.generate(
              competition.totalRaces,
              (index) => 'Armada ${index + 1}',
            ),
      );

      // Dados
      for (var participant in competition.participants) {
        var row = [participant.name];
        for (int i = 0; i < competition.totalRaces; i++) {
          final result = competition.results.firstWhere(
            (r) => r.participantId == participant.id && r.raceNumber == i,
            orElse: () => RaceResult(
              participantId: participant.id,
              raceNumber: i,
              result: '',
            ),
          );
          row.add(result.result.isEmpty ? '-' : result.result);
        }
        sheet.appendRow(row);
      }

      final output = await getApplicationDocumentsDirectory();
      final fileName =
          '${competition.name}_${DateTime.now().millisecondsSinceEpoch}.xlsx';
      final file = File('${output.path}/$fileName');
      await file.writeAsBytes(excelFile.encode()!);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Excel exportado: ${file.path}')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao exportar Excel: $e')),
      );
    }
  }

  /// Constrói tabela PDF
  static pw.Widget _buildPdfTable(Competition competition) {
    return pw.Table(
      border: pw.TableBorder.all(),
      children: [
        pw.TableRow(
          children: [
            pw.Text('Participante'),
            ...List.generate(
              competition.totalRaces,
              (index) => pw.Text('${index + 1}'),
            ),
          ],
        ),
        ...competition.participants.map((participant) {
          return pw.TableRow(
            children: [
              pw.Text(participant.name),
              ...List.generate(
                competition.totalRaces,
                (index) {
                  final result = competition.results.firstWhere(
                    (r) =>
                        r.participantId == participant.id &&
                        r.raceNumber == index,
                    orElse: () => RaceResult(
                      participantId: participant.id,
                      raceNumber: index,
                      result: '',
                    ),
                  );
                  return pw.Text(result.result.isEmpty ? '-' : result.result);
                },
              ),
            ],
          );
        }),
      ],
    );
  }

  /// Constrói estatísticas PDF
  static pw.Widget _buildPdfStatistics(Competition competition) {
    int pCount = 0;
    int nCount = 0;

    for (var result in competition.results) {
      if (result.result == 'P') pCount++;
      if (result.result == 'N') nCount++;
    }

    final total = pCount + nCount;
    final pPercentage = total > 0 ? (pCount / total * 100).toStringAsFixed(1) : '0';
    final nPercentage = total > 0 ? (nCount / total * 100).toStringAsFixed(1) : '0';

    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          'Estatísticas',
          style: pw.TextStyle(
            fontSize: 14,
            fontWeight: pw.FontWeight.bold,
          ),
        ),
        pw.SizedBox(height: 8),
        pw.Text('Praia (P): $pCount ($pPercentage%)'),
        pw.Text('Nado (N): $nCount ($nPercentage%)'),
        pw.Text('Total: $total'),
      ],
    );
  }
}
