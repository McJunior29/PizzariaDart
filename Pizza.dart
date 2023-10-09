import 'dart:io';

class Pizza {
  int codigo;
  String sabor;
  double preco;

  Pizza(this.codigo, this.sabor, this.preco);

  String toString() {
    return 'Código: $codigo, Sabor: $sabor, Preço: $preco';
  }
}