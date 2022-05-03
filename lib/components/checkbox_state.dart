class CheckboxState {
  final String title;
  final String subtitle;
  final num price;
  final num duplicate;

  bool value;
  CheckboxState(
      {required this.title,
      required this.subtitle,
      required this.price,
      this.value = false,
      required this.duplicate});

    CheckboxState fromJson(Map<String, dynamic> json)=> CheckboxState(
      title: json['name'], 
      subtitle: json['desc'],
       price: json['price'], 
       duplicate: json['switches']);
}
