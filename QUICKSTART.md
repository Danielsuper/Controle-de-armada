# Guia Rápido - Controle de Armada

## 🚀 Início Rápido

### 1. Clonar e Instalar
```bash
git clone https://github.com/Danielsuper/controle-de-armada.git
cd controle-de-armada
flutter pub get
flutter pub run build_runner build
```

### 2. Executar
```bash
# Android/iOS
flutter run

# Windows
flutter run -d windows
```

## 📋 Fluxo Principal

```
┌─────────────────┐
│  Tela Inicial   │
└────────┬────────┘
         │
    ┌────┴────┬─────────┬──────────────┐
    │          │         │              │
    ▼          ▼         ▼              ▼
┌─────┐  ┌────────┐ ┌──────┐      ┌──────────┐
│Nova │  │Continuar Planilhas   │Configurações
│Plan.│  │Última   Salvas       │
└──┬──┘  └───┬────┴──────┬─────┘  └──────────┘
   │         │           │
   └─────────┼───────────┘
             │
             ▼
   ┌──────────────────┐
   │ Nova Competição  │
   │ - Nome           │
   │ - Data           │
   │ - Qtd Armadas    │
   └────────┬─────────┘
            │
            ▼
   ┌──────────────────┐
   │Cad. Participantes│
   │ - Nome           │
   │ - Número (opt)   │
   └────────┬─────────┘
            │
            ▼
   ┌──────────────────┐
   │ Registro Rápido  │
   │ [P] [N]          │
   │ Automático       │
   └────────┬─────────┘
            │
            ▼
   ┌──────────────────┐
   │ Salvo Automático │
   │ Exportar PDF/XLS │
   └──────────────────┘
```

## ⚡ Operações Rápidas

| Ação | Como |
|------|------|
| Registrar P | Clique botão verde "P" |
| Registrar N | Clique botão vermelho "N" |
| Desfazer | Clique undo na AppBar |
| Refazer | Clique redo na AppBar |
| Ver Stats | Clique chart na AppBar |
| Mudar Tema | Settings > Tema |
| Renomear | Planilhas Salvas > Menu |
| Duplicar | Planilhas Salvas > Menu |
| Excluir | Planilhas Salvas > Menu |

## 📊 Estrutura de Dados

```dart
Competition
 ├─ id: String
 ├─ name: String
 ├─ date: DateTime
 ├─ totalRaces: int
 ├─ participants: List<Participant>
 │   ├─ id: String
 │   ├─ name: String
 │   ├─ number: String?
 │   └─ order: int
 ├─ results: List<RaceResult>
 │   ├─ id: String
 │   ├─ participantId: String
 │   ├─ raceNumber: int
 │   ├─ result: String (P|N)
 │   └─ timestamp: DateTime
 ├─ createdAt: DateTime
 └─ updatedAt: DateTime
```

## 🎨 Temas

### Cores Primárias
- **Light**: #6200EE (Roxo)
- **Dark**: #BB86FC (Roxo Claro)

### Cores Secundárias
- **Praia (P)**: 🟢 Verde (#4CAF50)
- **Nado (N)**: 🔴 Vermelho (#E53935)

## 📱 Telas

### Home Screen
- 3 botões principais
- Informações da última competição

### New Competition Screen
- Nome da competição
- Data (automática)
- Quantidade de armadas (slider)

### Participants Registration Screen
- Lista de participantes
- Add/Edit/Delete
- Validação de entrada

### Competition Main Screen
- Tabela de resultados
- 2 FABs (P e N)
- Estatísticas em tempo real
- Undo/Redo

### Saved Competitions Screen
- Lista de todas as competições
- Ações por competição (continuar, renomear, duplicar, excluir)
- Informações de data e participantes

### Settings Screen
- Seleção de tema
- Backup/Restauração
- Informações da versão

## 🔧 Configuração Personalizada

### Alterar Tema Primário

Em `lib/config/theme/app_theme.dart`:
```dart
static const Color _lightPrimary = Color(0xFF6200EE); // Altere aqui
static const Color _darkPrimary = Color(0xFFBB86FC);
```

### Alterar Cores P/N

Em `lib/presentation/screens/competition_main_screen.dart`:
```dart
FloatingActionButton.extended(
  backgroundColor: Colors.green, // Altere cor P
  ...
)
```

## 🐛 Troubleshooting

### Erro: "Hive box not found"
```bash
flutter clean
flutter pub run build_runner build --delete-conflicting-outputs
flutter run
```

### Erro: "Context is null"
Certifique-se de que está usando `mounted` em async:
```dart
if (mounted) {
  ScaffoldMessenger.of(context).showSnackBar(...);
}
```

### Erro: "Package not found"
```bash
flutter pub get
flutter pub upgrade
```

## 📦 Build para Produção

### Android APK
```bash
flutter build apk --release
```

### Android App Bundle
```bash
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

## 🔐 Permissões

### Android (AndroidManifest.xml)
- `INTERNET`
- `READ_EXTERNAL_STORAGE`
- `WRITE_EXTERNAL_STORAGE`

### iOS (Info.plist)
- Nenhuma permissão adicional necessária

## 📝 Notas Importantes

✅ Dados são salvos automaticamente a cada toque
✅ Aplicativo funciona completamente offline
✅ Sem necessidade de login ou conta
✅ Sem coleta de dados pessoais (quando offline)
✅ Preparado para sincronização com Firebase

## 🚀 Próximas Versões

- [ ] Firebase Sync
- [ ] Cloud Backup
- [ ] Compartilhamento
- [ ] Ranking Detalhado
- [ ] Gráficos
- [ ] Modo Campeonato
- [ ] Multi-idioma

## 📞 Suporte

- 🐛 Bugs: Abra uma issue no GitHub
- 💡 Sugestões: Discuss no GitHub
- 📧 Email: Contacte através do GitHub

---

**Versão**: 1.0.0
**Última Atualização**: Jul/2024
