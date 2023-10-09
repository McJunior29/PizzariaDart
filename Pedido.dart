import 'dart:io';

class Pedido {
  int codigo;
  DateTime data;
  List<int> pizzas;

  Pedido(this.codigo, this.data, this.pizzas);
}