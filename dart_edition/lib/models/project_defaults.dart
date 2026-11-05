/// App-owned seed data. Stored project names are never translated on display.
class ProjectDefaults {
  static const chapterName = 'Chapter1';

  const ProjectDefaults({
    this.folderName = '資料夾 1',
    this.storylineName = '序章',
    this.storylineType = '開場',
    this.locationName = '主要場景',
    this.timelineTrackName = '時間軸 1',
    this.timelineOriginLabel = '故事開始',
    this.untitledTrackName = '未命名軌道',
  });

  final String folderName;
  final String storylineName;
  final String storylineType;
  final String locationName;
  final String timelineTrackName;
  final String timelineOriginLabel;
  final String untitledTrackName;
}
