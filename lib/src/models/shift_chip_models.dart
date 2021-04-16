class ItemShiftChoice {
  final int id;
  final String label;

  ItemShiftChoice(this.id, this.label);
}

List<ItemShiftChoice> getItemShiftChoice() {
  return <ItemShiftChoice>[
    ItemShiftChoice(1, 'Shift 1'),
    ItemShiftChoice(2, 'Shift 2'),
    ItemShiftChoice(3, 'Shift 3'),
  ];
}
