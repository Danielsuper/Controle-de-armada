# Dicas e Boas Práticas - Controle de Armada

## Performance

### Otimizar Rebuild de Widgets
```dart
// ❌ Ruim - Reconstrói todo o widget
Consumer<CompetitionProvider>(
  builder: (context, provider, _) {
    return Column(
      children: [
        Text(provider.currentCompetition?.name ?? ''),
        Text(provider.currentParticipantIndex.toString()),
      ],
    );
  },
);

// ✅ Bom - Só reconstrói o necessário
Selector<CompetitionProvider, String>(
  selector: (context, provider) => provider.currentCompetition?.name ?? '',
  builder: (context, name, _) => Text(name),
)
```

### Lazy Loading
```dart
ListView.builder(
  itemCount: items.length,
  itemBuilder: (context, index) {
    return ItemWidget(item: items[index]);
  },
)
```

## State Management

### Usar Provider Corretamente
```dart
// ❌ Ruim
final provider = Provider.of<CompetitionProvider>(context);

// ✅ Bom (em build)
Consumer<CompetitionProvider>(
  builder: (context, provider, _) => ...,
)

// ✅ Bom (em callback)
context.read<CompetitionProvider>().method()
```

## Navegação

### Fechar Múltiplas Telas
```dart
// Remover telas até a home
Navigator.of(context).pushAndRemoveUntil(
  MaterialPageRoute(builder: (context) => const HomeScreen()),
  (route) => route.isFirst,
);
```

## Erros Comuns

### 1. Método Chamado Durante Build
```dart
// ❌ Ruim
@override
Widget build(BuildContext context) {
  provider.loadData(); // Erro!
  return Container();
}

// ✅ Bom
@override
void initState() {
  super.initState();
  provider.loadData();
}
```

### 2. Disposão de Recursos
```dart
// ✅ Sempre dispose controllers
@override
void dispose() {
  _controller.dispose();
  super.dispose();
}
```

### 3. BuildContext Inválido
```dart
// ❌ Ruim
async {
  await future;
  ScaffoldMessenger.of(context).showSnackBar(...); // Pode falhar
}

// ✅ Bom
if (mounted) {
  ScaffoldMessenger.of(context).showSnackBar(...);
}
```

## Debug

### Verificar Rebuilds
```dart
@override
Widget build(BuildContext context) {
  print('Build HomeScreen'); // Ver quantas vezes reconstrói
  return Container();
}
```

### Breakpoints
Use DevTools para adicionar breakpoints e inspecionar variáveis.

## Teste

### Exemplo de Teste
```dart
void main() {
  group('CompetitionProvider', () {
    test('createCompetition adiciona nova competição', () async {
      final provider = CompetitionProvider();
      
      expect(provider.getAllCompetitions().length, 0);
      
      await provider.createCompetition(
        name: 'Test',
        totalRaces: 10,
        participants: [],
      );
      
      expect(provider.getAllCompetitions().length, 1);
    });
  });
}
```

## Recursos

- [Flutter Best Practices](https://flutter.dev/docs/testing/best-practices)
- [Dart Effective Guide](https://dart.dev/guides/language/effective-dart)
- [Provider Documentation](https://pub.dev/packages/provider)

---

**Versão**: 1.0.0
**Data**: Jul/2024
