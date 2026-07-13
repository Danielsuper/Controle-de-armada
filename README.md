# README - Controle de Armada

## Descrição

Controle de Armada é um aplicativo profissional desenvolvido em Flutter para registrar rapidamente os resultados de armadas em competições.

## Características Principais

✅ **Multiplataforma**
- Android
- iOS
- Windows
- Código único para todas as plataformas

✅ **Design e UX**
- Material Design 3
- Tema claro e escuro
- Botões grandes e fáceis de usar
- Animaações suaves
- Interface intuitiva e rápida

✅ **Funcionalidades**
- Criação rápida de competições
- Cadastro de participantes ilimitado
- Registro rápido de resultados (P/N)
- Salvamento automático
- Desfazer/Refazer
- Estatísticas em tempo real
- Exportação para PDF e Excel

✅ **Banco de Dados**
- Hive para máxima performance
- Preparado para Firebase
- Sincronização futura

## Estrutura do Projeto

```
lib/
├── config/
│   ├── constants/
│   │   └── app_constants.dart
│   ├── dimensions/
│   │   └── app_dimensions.dart
│   └── theme/
│       └── app_theme.dart
├── data/
│   ├── models/
│   │   └── models.dart
│   └── repositories/
├── domain/
├── presentation/
│   ├── providers/
│   │   ├── competition_provider.dart
│   │   └── theme_provider.dart
│   ├── screens/
│   │   ├── home_screen.dart
│   │   ├── new_competition_screen.dart
│   │   ├── participants_registration_screen.dart
│   │   ├── competition_main_screen.dart
│   │   ├── saved_competitions_screen.dart
│   │   └── settings_screen.dart
│   └── widgets/
│       ├── custom_button.dart
│       ├── custom_card.dart
│       └── empty_state_widget.dart
├── utils/
│   ├── app_logger.dart
│   ├── date_format_helper.dart
│   ├── dialog_helper.dart
│   ├── export_helper.dart
│   └── validation_helper.dart
└── main.dart
```

## Instalação

### Pré-requisitos

- Flutter 3.0+
- Dart 3.0+
- Android Studio (para Android)
- Xcode (para iOS)
- Visual Studio (para Windows)

### Passos

1. Clone o repositório:
```bash
git clone https://github.com/Danielsuper/controle-de-armada.git
cd controle-de-armada
```

2. Instale as dependências:
```bash
flutter pub get
```

3. Gere os arquivos Hive (models.g.dart):
```bash
flutter pub run build_runner build
```

4. Execute o aplicativo:
```bash
flutter run
```

## Uso

### 1. Tela Inicial
- **Nova Planilha**: Cria uma nova competição
- **Continuar Última**: Retoma a última competição ativa
- **Planilhas Salvas**: Lista todas as competições

### 2. Nova Planilha
1. Insira o nome da competição
2. Selecione a data (preenchida automaticamente)
3. Defina a quantidade de armadas (padrão: 10)
4. Clique em "Próximo"

### 3. Cadastro de Participantes
1. Insira o nome do participante
2. Insira o número (opcional)
3. Clique em "+" para adicionar
4. Clique em "Iniciar Competição"

### 4. Registro de Resultados
- Clique em **P** para Praia
- Clique em **N** para Nado
- O foco avança automaticamente
- Resultados são salvos automaticamente
- Use **Desfazer/Refazer** conforme necessário

### 5. Exportação
- **PDF**: Exporta relatório completo
- **Excel**: Exporta planilha de dados

## Configurações

- **Tema**: Alterne entre claro, escuro ou automático
- **Backup**: Crie e restaure backups (em desenvolvimento)

## Arquitetura

O projeto segue a arquitetura limpa com MVVM:

- **Models**: Estruturas de dados (Competition, Participant, RaceResult)
- **Providers**: Gerenciamento de estado (CompetitionProvider, ThemeProvider)
- **Screens**: Telas e UI
- **Widgets**: Componentes reutilizáveis
- **Utils**: Funções auxiliares

## Dependências Principais

- **provider**: State management
- **hive_flutter**: Banco de dados local
- **google_fonts**: Fontes personalizadas
- **pdf**: Exportação PDF
- **excel**: Exportação Excel
- **firebase_core**: Preparação Firebase

## Contribuição

Contribuições são bem-vindas! Por favor:

1. Faça um fork
2. Crie uma branch para sua feature (`git checkout -b feature/AmazingFeature`)
3. Commit suas mudanças (`git commit -m 'Add some AmazingFeature'`)
4. Push para a branch (`git push origin feature/AmazingFeature`)
5. Abra um Pull Request

## Licença

Este projeto está licenciado sob a MIT License - veja o arquivo [LICENSE](LICENSE) para mais detalhes.

## Autor

**Danielsuper**
- GitHub: [@Danielsuper](https://github.com/Danielsuper)

## Suporte

Para suporte, envie uma issue no repositório.

---

**Versão**: 1.0.0  
**Data**: Jul/2024
