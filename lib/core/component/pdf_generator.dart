import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

/// PDF 문서 생성기
///
/// 텍스트 콘텐츠를 구조화된 PDF 문서로 변환합니다.
///
/// 주요 기능:
/// - 마크다운 형식의 텍스트를 PDF로 변환
/// - 단일/두 단 레이아웃 지원
/// - 사용자 정의 스타일 및 포맷 옵션
class PdfGenerator {
  /// PDF 문서를 생성합니다.
  ///
  /// 매개변수:
  /// - [headerText] : PDF 문서의 제목
  /// - [contentsText] : PDF 문서의 본문 (마크다운 형식 지원)
  /// - [headerStyle] : 제목 스타일 (선택적)
  /// - [contentsStyle] : 본문 스타일 (선택적)
  /// - [pageFormat] : 페이지 크기 (기본값: A4)
  /// - [headerHeight] : 제목과 본문 사이 간격 (기본값: 20.0)
  /// - [useDoubleColumn] : 두 단 레이아웃 사용 여부 (기본값: false)
  /// - [columnSpacing] : 두 단 사이 간격 (기본값: 10.0)
  ///
  /// 반환값: 생성된 PDF 문서 바이트 데이터 (Uint8List)
  ///
  /// 사용 예시:
  /// ```dart
  /// // 기본 사용법
  /// final pdfBytes = await PdfGenerator().generatePdf(
  ///   headerText: '문서 제목',
  ///   contentsText: '문서 내용...',
  /// );
  ///
  /// // 두 단 레이아웃 사용
  /// final pdfBytes = await PdfGenerator().generatePdf(
  ///   headerText: '문서 제목',
  ///   contentsText: '# 대제목\n## 중제목\n일반 텍스트\n- 목록 항목',
  ///   useDoubleColumn: true,
  /// );
  /// ```
  Future<Uint8List> generatePdf({
    required String headerText,
    required String contentsText,
    pw.TextStyle? headerStyle,
    pw.TextStyle? contentsStyle,
    PdfPageFormat pageFormat = PdfPageFormat.a4,
    double headerHeight = 20.0,
    bool useDoubleColumn = false,
    double columnSpacing = 10.0,
  }) async {
    // 1. 스타일 설정
    final effectiveHeaderStyle = _createHeaderStyle(headerStyle);
    final effectiveContentStyle = _createContentStyle(contentsStyle);

    // 2. 콘텐츠 처리
    final contentLines = contentsText.split('\n');

    // 3. PDF 문서 생성
    final pdf = pw.Document();

    // 4. 페이지 추가
    pdf.addPage(
      pw.MultiPage(
        pageFormat: pageFormat,
        build: (pw.Context context) {
          // 제목 및 콘텐츠 위젯 준비
          final widgets = _buildHeaderWidget(
            headerText: headerText,
            headerStyle: effectiveHeaderStyle,
            headerHeight: headerHeight,
          );

          // 레이아웃 유형에 따라 콘텐츠 구성
          if (useDoubleColumn) {
            widgets.add(
              _createDoubleColumnLayout(
                contentLines: contentLines,
                contentStyle: effectiveContentStyle,
                pageFormat: pageFormat,
                columnSpacing: columnSpacing,
              ),
            );
          } else {
            widgets.addAll(
              _createSingleColumnLayout(
                contentLines: contentLines,
                contentStyle: effectiveContentStyle,
                headerStyle: effectiveHeaderStyle,
              ),
            );
          }

          return widgets;
        },
      ),
    );

    // 5. PDF 생성 완료
    return pdf.save();
  }

  /// 제목 위젯을 구성합니다
  List<pw.Widget> _buildHeaderWidget({
    required String headerText,
    required pw.TextStyle headerStyle,
    required double headerHeight,
  }) {
    return [
      pw.Header(level: 0, child: pw.Text(headerText, style: headerStyle)),
      pw.SizedBox(height: headerHeight),
    ];
  }

  /// 단일 컬럼 레이아웃을 생성합니다
  List<pw.Widget> _createSingleColumnLayout({
    required List<String> contentLines,
    required pw.TextStyle contentStyle,
    required pw.TextStyle headerStyle,
  }) {
    final widgets = <pw.Widget>[];

    for (final line in contentLines) {
      final trimmedLine = line.trim();

      if (trimmedLine.isEmpty) continue; // 빈 줄 무시

      // 마크다운 형식에 따라 위젯 추가
      if (trimmedLine.startsWith('# ')) {
        // 대제목 (Header 레벨 1)
        widgets.add(
          _createHeading(
            text: trimmedLine.substring(2),
            style: headerStyle.copyWith(fontSize: 20),
            level: 1,
          ),
        );
      } else if (trimmedLine.startsWith('## ')) {
        // 중제목 (Header 레벨 2)
        widgets.add(
          _createHeading(
            text: trimmedLine.substring(3),
            style: headerStyle.copyWith(fontSize: 18),
            level: 2,
          ),
        );
      } else if (trimmedLine.startsWith('### ')) {
        // 소제목 (Header 레벨 3)
        widgets.add(
          _createHeading(
            text: trimmedLine.substring(4),
            style: headerStyle.copyWith(fontSize: 16),
            level: 3,
          ),
        );
      } else if (trimmedLine.startsWith('- ')) {
        // 불릿 포인트
        widgets.add(
          pw.Bullet(text: trimmedLine.substring(2), style: contentStyle),
        );
      } else {
        // 일반 텍스트 (단락)
        widgets.add(pw.Paragraph(text: trimmedLine, style: contentStyle));
      }
    }

    return widgets;
  }

  /// 제목 위젯을 생성합니다
  pw.Widget _createHeading({
    required String text,
    required pw.TextStyle style,
    required int level,
  }) {
    return pw.Header(level: level, child: pw.Text(text, style: style));
  }

  /// 두 단 레이아웃을 생성합니다
  pw.Widget _createDoubleColumnLayout({
    required List<String> contentLines,
    required pw.TextStyle contentStyle,
    required PdfPageFormat pageFormat,
    double columnSpacing = 10.0,
  }) {
    // 컬럼에 들어갈 위젯 목록
    final columnItems = <pw.Widget>[];

    // 마크다운 형식에 따라 위젯 생성
    for (final line in contentLines) {
      final trimmedLine = line.trim();

      if (trimmedLine.isEmpty) continue; // 빈 줄 무시

      if (trimmedLine.startsWith('# ')) {
        // 대제목
        columnItems.add(
          _createColumnTextWidget(
            text: trimmedLine.substring(2),
            style: contentStyle.copyWith(
              fontSize: 18,
              fontWeight: pw.FontWeight.bold,
            ),
            bottomPadding: 5,
          ),
        );
      } else if (trimmedLine.startsWith('## ')) {
        // 중제목
        columnItems.add(
          _createColumnTextWidget(
            text: trimmedLine.substring(3),
            style: contentStyle.copyWith(
              fontSize: 16,
              fontWeight: pw.FontWeight.bold,
            ),
            bottomPadding: 5,
          ),
        );
      } else if (trimmedLine.startsWith('- ')) {
        // 불릿 포인트
        columnItems.add(
          _createColumnBulletWidget(
            text: trimmedLine.substring(2),
            style: contentStyle,
          ),
        );
      } else {
        // 일반 텍스트
        columnItems.add(
          _createColumnTextWidget(
            text: trimmedLine,
            style: contentStyle,
            bottomPadding: 5,
            justify: true,
          ),
        );
      }
    }

    // 각 항목의 너비 계산 (두 단 레이아웃용)
    final columnWidth = (pageFormat.availableWidth / 2) - (columnSpacing / 2);

    // 두 단 레이아웃 생성
    return pw.Wrap(
      direction: pw.Axis.vertical,
      spacing: 5,
      runSpacing: columnSpacing,
      children:
          columnItems.map((widget) {
            return pw.Container(width: columnWidth, child: widget);
          }).toList(),
    );
  }

  /// 컬럼용 텍스트 위젯을 생성합니다
  pw.Widget _createColumnTextWidget({
    required String text,
    required pw.TextStyle style,
    double bottomPadding = 0,
    bool justify = false,
  }) {
    return pw.Padding(
      padding: pw.EdgeInsets.only(bottom: bottomPadding),
      child: pw.Text(
        text,
        style: style,
        textAlign: justify ? pw.TextAlign.justify : null,
      ),
    );
  }

  /// 컬럼용 불릿 위젯을 생성합니다
  pw.Widget _createColumnBulletWidget({
    required String text,
    required pw.TextStyle style,
  }) {
    return pw.Padding(
      padding: const pw.EdgeInsets.only(left: 10, bottom: 3),
      child: pw.Row(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text('• ', style: style),
          pw.Expanded(child: pw.Text(text, style: style)),
        ],
      ),
    );
  }

  /// 제목 스타일을 생성합니다
  pw.TextStyle _createHeaderStyle(pw.TextStyle? baseStyle) {
    return pw.TextStyle(
      fontSize: baseStyle?.fontSize ?? 24,
      fontWeight: pw.FontWeight.bold,
      color: baseStyle?.color,
    );
  }

  /// 본문 스타일을 생성합니다
  pw.TextStyle _createContentStyle(pw.TextStyle? baseStyle) {
    return pw.TextStyle(
      fontSize: baseStyle?.fontSize ?? 12,
      color: baseStyle?.color,
    );
  }
}
