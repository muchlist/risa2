class ItemShiftChoice {
  ItemShiftChoice(this.id, this.label);
  final int id;
  final String label;
}

List<ItemShiftChoice> getItemShiftChoice() {
  return <ItemShiftChoice>[
    ItemShiftChoice(1, 'Shift 1'),
    ItemShiftChoice(2, 'Shift 2'),
    ItemShiftChoice(3, 'Shift 3'),
  ];
}
