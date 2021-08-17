class ItemMaintnenanceChoice {
  ItemMaintnenanceChoice(this.id, this.label);
  final int id;
  final String label;
}

List<ItemMaintnenanceChoice> getItemMaintenanceChoice() {
  return <ItemMaintnenanceChoice>[
    ItemMaintnenanceChoice(1, 'Bulanan'),
    ItemMaintnenanceChoice(2, 'Triwulan'),
  ];
}
