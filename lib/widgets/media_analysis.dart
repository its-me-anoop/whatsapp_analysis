import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:whatsapp_analysis/models/chat_message.dart';
import 'package:whatsapp_analysis/widgets/indicator.dart';

class MediaAnalysisWidget extends StatefulWidget {
  final List<ChatMessage> chatMessages;

  // Constructor for MediaAnalysisWidget
  const MediaAnalysisWidget({
    super.key,
    required this.chatMessages,
  });

  @override
  MediaAnalysisWidgetState createState() => MediaAnalysisWidgetState();
}

class MediaAnalysisWidgetState extends State<MediaAnalysisWidget> {
  int touchedIndex = -1;

  // Calculate media analysis data
  Map<String, int> getMediaAnalysis() {
    Map<String, int> mediaCount = {
      'Images': 0,
      'Videos': 0,
      'Documents': 0,
    };

    for (var message in widget.chatMessages) {
      final text = message.text;
      if (text.contains('<attached: PHOTO') ||
          text.contains('.jpg>') ||
          text.contains('.jpeg>') ||
          text.contains('.png>') ||
          text.contains('.gif>') ||
          text.contains('.bmp>') ||
          text.contains('.tiff>') ||
          text.contains('.webp>') ||
          text.contains('.heif>')) {
        mediaCount['Images'] = (mediaCount['Images'] ?? 0) + 1;
      } else if (text.contains('<attached: VIDEO') ||
          text.contains('.mp4>') ||
          text.contains('.avi>') ||
          text.contains('.mkv>') ||
          text.contains('.mov>') ||
          text.contains('.wmv>') ||
          text.contains('.flv>')) {
        mediaCount['Videos'] = (mediaCount['Videos'] ?? 0) + 1;
      } else if (text.contains('<attached: DOCUMENT') ||
          text.contains('.pdf>') ||
          text.contains('.doc>') ||
          text.contains('.docx>') ||
          text.contains('.ppt>') ||
          text.contains('.pptx>') ||
          text.contains('.xls>') ||
          text.contains('.xlsx>') ||
          text.contains('.txt>') ||
          text.contains('.rtf>') ||
          text.contains('.csv>')) {
        mediaCount['Documents'] = (mediaCount['Documents'] ?? 0) + 1;
      }
    }

    return mediaCount;
  }

  @override
  Widget build(BuildContext context) {
    final mediaData = getMediaAnalysis();

    if (mediaData.isEmpty) {
      // Display "No Attachments" when there are no attachments
      return const Card(
        child: Padding(
          padding: EdgeInsets.all(20.0),
          child: Center(
            child: Text('No Attachments', style: TextStyle(fontSize: 18)),
          ),
        ),
      );
    }

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: <Widget>[
            const Text(
              'Media Analysis',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 200,
                  width: 200,
                  child: PieChart(
                    // Pie chart to display media analysis
                    PieChartData(
                      pieTouchData: PieTouchData(
                        touchCallback: (FlTouchEvent event, pieTouchResponse) {
                          setState(() {
                            if (!event.isInterestedForInteractions ||
                                pieTouchResponse == null ||
                                pieTouchResponse.touchedSection == null) {
                              touchedIndex = -1;
                              return;
                            }
                            touchedIndex = pieTouchResponse
                                .touchedSection!.touchedSectionIndex;
                          });
                        },
                        mouseCursorResolver:
                            (FlTouchEvent event, pieTouchResponse) {
                          setState(() {
                            if (!event.isInterestedForInteractions ||
                                pieTouchResponse == null ||
                                pieTouchResponse.touchedSection == null) {
                              touchedIndex = -1;
                            } else {
                              touchedIndex = pieTouchResponse
                                  .touchedSection!.touchedSectionIndex;
                            }
                          });

                          // Return the cursor here
                          return SystemMouseCursors.click;
                        },
                      ),
                      borderData: FlBorderData(
                        show: true,
                      ),
                      sectionsSpace: 0,
                      centerSpaceRadius: 40,
                      sections: mediaData.entries.map((entry) {
                        final isTouched = entry.value == touchedIndex;
                        final fontSize = isTouched ? 25.0 : 16.0;
                        final radius = isTouched ? 60.0 : 50.0;
                        const shadows = [
                          Shadow(color: Colors.black, blurRadius: 2)
                        ];
                        return PieChartSectionData(
                          color: _getColorForMediaType(entry.key),
                          value: entry.value.toDouble(),
                          title: '${entry.value}',
                          radius: radius,
                          titleStyle: TextStyle(
                            fontSize: fontSize,
                            fontWeight: FontWeight.bold,
                            color: const Color(0xffffffff),
                            shadows: shadows,
                          ),
                          titlePositionPercentageOffset: 0.55,
                        );
                      }).toList(),
                    ),
                    swapAnimationDuration: const Duration(milliseconds: 150),
                    swapAnimationCurve: Curves.linear,
                  ),
                ),
                const SizedBox(
                  width: 20,
                ),
                const Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Indicator(
                      color: Color(0xff0293ee),
                      text: 'Images',
                      isSquare: true,
                    ),
                    SizedBox(
                      height: 4,
                    ),
                    Indicator(
                      color: Color(0xfff8b250),
                      text: 'Videos',
                      isSquare: true,
                    ),
                    SizedBox(
                      height: 4,
                    ),
                    Indicator(
                      color: Color(0xff845bef),
                      text: 'Documents',
                      isSquare: true,
                    ),
                    SizedBox(
                      height: 18,
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Color _getColorForMediaType(String mediaType) {
    if (mediaType == 'Images') {
      return const Color(0xff0293ee);
    } else if (mediaType == 'Videos') {
      return const Color(0xfff8b250);
    } else if (mediaType == 'Documents') {
      return const Color(0xff845bef);
    }
    return Colors.grey; // Default color
  }
}
