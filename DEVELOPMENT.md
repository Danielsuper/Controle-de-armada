# Controle de Armada - Instruções de Desenvolvimento

## Configuração do Ambiente

### Windows/Mac/Linux

1. **Instale Flutter**
```bash
git clone https://github.com/flutter/flutter.git
cd flutter
export PATH="$PATH:`pwd`/bin"
flutter doctor
```

2. **Instale Dependências do Projeto**
```bash
cd controle-de-armada
flutter pub get
```

3. **Gere Modelos Hive**
```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

## Rodando o Projeto

### Android
```bash
flutter run -d <device_id>
```

### iOS (Mac)
```bash
flutter run -d ios
```

### Windows
```bash
flutter run -d windows
```

## Estrutura de Pastas

```
controle-de-armada/
├── lib/                      # Código Dart
├── android/                 # Configurações Android
├── ios/                     # Configurações iOS
├── windows/                 # Configurações Windows
├── test/                    # Testes (a implementar)
├── pubspec.yaml             # Dependências
├── pubspec.lock             # Lock de versões
├── README.md                # Documentação
├── PUBLISH.md               # Guia de Publicação
├── CHANGELOG.md             # Histórico de Versões
├── analysis_options.yaml    # Opções de Análise
└── .gitignore               # Arquivos Ignorados
```

## Padrões de Código

### Nomenclatura
- **Classes**: PascalCase (`HomeScreen`, `CompetitionProvider`)
- **Variáveis/Funções**: camelCase (`participantList`, `getCompetition()`)
- **Constantes**: UPPER_CASE (`MAX_RACES`, `DEFAULT_RACES`)
- **Arquivos**: snake_case (`home_screen.dart`)

### Organização de Imports
```dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../data/models/models.dart';
import '../../presentation/providers/theme_provider.dart';
```

### Documentação
```dart
/// Descrição da classe/função
class MyClass {
  /// Descrição do método
  void myMethod() {
    // Código
  }
}
```

## Testes

### Executar Testes
```bash
flutter test
```

### Exemplo de Teste
```dart
void main() {
  test('description', () {
    expect(result, expectedValue);
  });
}
```

## Build e Release

### Android
```bash
flutter build apk --release
flutter build appbundle --release
```

### iOS
```bash
flutter build ios --release
```

### Windows
```bash
flutter build windows --release
```

## Debug

### Print Logs
```dart
AppLogger.info('Mensagem');
AppLogger.error('Erro', error, stackTrace);
```

### DevTools
```bash
flutter pub global activate devtools
flutter pub global run devtools
```

## Troubleshooting

### Build Falha
```bash
flutter clean
flutter pub get
flutter pub run build_runner build --delete-conflicting-outputs
```

### Problemas de Dependências
```bash
flutter pub upgrade
flutter pub downgrade
```

### Cache
```bash
flutter clean
rm -rf pubspec.lock
flutter pub get
```

## Recursos Útel

- [Flutter Docs](https://flutter.dev/docs)
- [Dart Docs](https://dart.dev/guides)
- [Provider Package](https://pub.dev/packages/provider)
- [Hive Database](https://docs.hivedb.dev/)
- [Material Design 3](https://m3.material.io/)

---

**Versão**: 1.0.0  
**Data**: Jul/2024
