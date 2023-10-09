import 'dart:io';

import 'Pedido.dart';
import 'Pizza.dart';

void main() {
  List<Pizza> pizzas = [];
  List<Pedido> pedidos = [];

  carregarDados(pizzas, pedidos);

  while (true) {
    print("\nMenu Principal:");
    print("1) Cadastrar pizza");
    print("2) Editar pizza");
    print("3) Remover pizza");
    print("4) Fazer pedido");
    print("5) Listar Pizzas");
    print("6) Listar Pedidos");
    print("7) Sair");

    String? input = stdin.readLineSync();
    var opcao = int.parse(input!);

    switch (opcao) {
      case 1:
        cadastrarPizza(pizzas);
        break;
      case 2:
        editarPizza(pizzas);
        break;
      case 3:
        removerPizza(pizzas);
        break;
      case 4:
        fazerPedido(pizzas, pedidos);
        break;
      case 5:
        listarPizzas(pizzas);
        break;
      case 6:
        listarPedidos(pedidos, pizzas);
        break;
      case 7:
        salvarDados(pizzas, pedidos);
        exit(0);
      default:
        print("Opção inválida.");
    }
  }
}

void carregarDados(List<Pizza> pizzas, List<Pedido> pedidos) {
  try {
    File file = File("pizzas.txt");

    if (file.existsSync()) {
      List<String> lines = file.readAsLinesSync();
      for (var line in lines) {
        var parts = line.split(",");
        if (parts.length == 3) {
          var codigo = int.parse(parts[0]);
          var sabor = parts[1];
          var preco = double.parse(parts[2]);
          pizzas.add(Pizza(codigo, sabor, preco));
        }
      }
    }

    file = File("pedidos.txt");
    if (file.existsSync()) {
      List<String> lines = file.readAsLinesSync();
      for (var line in lines) {
        var parts = line.split(",");
        if (parts.length >= 2) {
          var codigo = int.parse(parts[0]);
          var data = DateTime.parse(parts[1]);
          var pizzas = parts.sublist(2).map((p) => int.parse(p)).toList();
          pedidos.add(Pedido(codigo, data, pizzas));
        }
      }
    }
  } catch (e) {
    print("Erro ao carregar dados: $e");
  }
}

void salvarDados(List<Pizza> pizzas, List<Pedido> pedidos) {
  try {
    File file = File("pizzas.txt");
    var lines = pizzas.map((p) => "${p.codigo},${p.sabor},${p.preco}").toList();
    file.writeAsStringSync(lines.join("\n"));

    file = File("pedidos.txt");
    lines = pedidos.map((pedido) =>
        "${pedido.codigo},${pedido.data},${pedido.pizzas.join(",")}").toList();
    file.writeAsStringSync(lines.join("\n"));
  } catch (e) {
    print("Erro ao salvar dados: $e");
  }
}

void cadastrarPizza(List<Pizza> pizzas) {
  print("Digite o código da pizza:");
  var codigo = int.parse(stdin.readLineSync()!);

  print("Digite o sabor da pizza:");
  String? sabor = stdin.readLineSync();

  print("Digite o preço da pizza:");
  var preco = double.parse(stdin.readLineSync()!);

  var pizza = Pizza(codigo, sabor!, preco);
  pizzas.add(pizza);
  print("Pizza cadastrada com sucesso!");
}

void editarPizza(List<Pizza> pizzas) {
  listarPizzas(pizzas);
  print("Digite o código da pizza que deseja editar:");
  var codigo = int.parse(stdin.readLineSync()!);
  var pizza = pizzas.firstWhere((p) => p.codigo == codigo);

  if (pizza != null) {
    print("Digite o novo sabor da pizza:");
    pizza.sabor = stdin.readLineSync()!;
    print("Digite o novo preço da pizza:");
    pizza.preco = double.parse(stdin.readLineSync()!);
    print("Pizza editada com sucesso!");
  } else {
    print("Pizza não encontrada.");
  }
}

void removerPizza(List<Pizza> pizzas) {
  listarPizzas(pizzas);
  print("Digite o código da pizza que deseja remover:");
  var codigo = int.parse(stdin.readLineSync()!);
  var pizza = pizzas.firstWhere((p) => p.codigo == codigo);

  if (pizza != null) {
    pizzas.remove(pizza);
    print("Pizza removida com sucesso!");
  } else {
    print("Pizza não encontrada.");
  }
}

void fazerPedido(List<Pizza> pizzas, List<Pedido> pedidos) {
  listarPizzas(pizzas);
  var pedidoPizzas = <Pizza>[];
  while (true) {
    print("Digite o código da pizza que deseja incluir no pedido (ou 0 para encerrar):");
    var codigo = int.parse(stdin.readLineSync()!);
    if (codigo == 0) {
      break;
    }
    var pizza = pizzas.firstWhere((p) => p.codigo == codigo);
    if (pizza != null) {
      pedidoPizzas.add(pizza);
      print("Pizza adicionada ao pedido.");
    } else {
      print("Pizza não encontrada.");
    }
  }

  if (pedidoPizzas.isNotEmpty) {
    var codigoPedido = pedidos.isEmpty ? 1 : pedidos.last.codigo + 1;
    var dataPedido = DateTime.now();
    var pedido = Pedido(codigoPedido, dataPedido, pedidoPizzas.map((p) => p.codigo).toList());
    pedidos.add(pedido);
    var totalPedido = pedidoPizzas.map((p) => p.preco).reduce((a, b) => a + b);
    print("Pedido realizado com sucesso! Total: $totalPedido");
  } else {
    print("Pedido vazio, nenhum pedido foi realizado.");
  }
}

void listarPizzas(List<Pizza> pizzas) {
  print("Lista de Pizzas:");
  for (var pizza in pizzas) {
    print(pizza);
  }
}

void listarPedidos(List<Pedido> pedidos, List<Pizza> pizzas) {
  print("Lista de Pedidos:");
  for (var pedido in pedidos) {
    var pizzasDoPedido = pedido.pizzas.map((codigoPizza) {
      var pizza = pizzas.firstWhere((p) => p.codigo == codigoPizza);
      return pizza != null ? pizza.sabor : "Pizza não encontrada";
    }).join(", ");

    print("Código do Pedido: ${pedido.codigo}, Data: ${pedido.data}, Pizzas: $pizzasDoPedido");
  }
}

