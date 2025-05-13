enum WorkbookSortOption {
  creationDateDesc('최신 순'),
  creationDateAsc('오래된 순'),
  nameAsc('이름 오름차순'),
  nameDesc('이름 내림차순');

  final String label;
  const WorkbookSortOption(this.label);
}