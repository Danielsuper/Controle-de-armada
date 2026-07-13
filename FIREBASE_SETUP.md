# Integração Firebase - Controle de Armada

## 🔑 Setup Firebase

### 1. Criar Projeto no Firebase

1. Acesse [Firebase Console](https://console.firebase.google.com)
2. Clique "Criar Projeto"
3. Nome: `Controle de Armada`
4. Ative Google Analytics (opcional)
5. Confirme criação

### 2. Registrar Apps

#### Android
1. No console, clique "Adicionar app" > Android
2. Package name: `com.danielsuper.controle_de_armada`
3. Download `google-services.json`
4. Coloque em `android/app/`

#### iOS
1. Clique "Adicionar app" > iOS
2. Bundle ID: `com.danielsuper.controleDeArmada`
3. Download `GoogleService-Info.plist`
4. Coloque em `ios/Runner/`

#### Windows
1. Firebase ainda tem suporte limitado para Windows
2. Alternativa: Use REST API ou implemente sincronização manual

### 3. Configurar Código

#### main.dart
```dart
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const ControleArmadasApp());
}
```

#### Gerar arquivo de configuração
```bash
flutter pub add firebase_core
flutter pub add firebase_database
flutter pub add firebase_auth
flutter pub add cloud_firestore
```

### 4. Estrutura Firestore

```
users/
  └─ {uid}/
      ├─ profile/
      │   ├─ email: string
      │   └─ createdAt: timestamp
      └─ competitions/
          └─ {competitionId}/
              ├─ name: string
              ├─ date: timestamp
              ├─ totalRaces: number
              ├─ participants/
              │   └─ {participantId}/
              │       ├─ name: string
              │       ├─ number: string
              │       └─ order: number
              ├─ results/
              │   └─ {resultId}/
              │       ├─ participantId: string
              │       ├─ raceNumber: number
              │       ├─ result: string (P|N)
              │       └─ timestamp: timestamp
              ├─ createdAt: timestamp
              └─ updatedAt: timestamp
```

### 5. Regras Firestore

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    match /users/{uid} {
      allow read, write: if request.auth.uid == uid;
      
      match /competitions/{document=**} {
        allow read, write: if request.auth.uid == uid;
      }
    }
  }
}
```

### 6. Implementar Sincronização

```dart
// lib/data/repositories/firebase_competition_repository.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseCompetitionRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  /// Sincroniza competição com Firebase
  Future<void> syncCompetition(Competition competition) async {
    try {
      final user = _auth.currentUser;
      if (user == null) throw Exception('Usuário não autenticado');

      await _firestore
          .collection('users')
          .doc(user.uid)
          .collection('competitions')
          .doc(competition.id)
          .set({
            'name': competition.name,
            'date': competition.date,
            'totalRaces': competition.totalRaces,
            'participants': competition.participants
                .map((p) => {
                      'id': p.id,
                      'name': p.name,
                      'number': p.number,
                      'order': p.order,
                    })
                .toList(),
            'results': competition.results
                .map((r) => {
                      'id': r.id,
                      'participantId': r.participantId,
                      'raceNumber': r.raceNumber,
                      'result': r.result,
                      'timestamp': r.timestamp,
                    })
                .toList(),
            'createdAt': competition.createdAt,
            'updatedAt': competition.updatedAt,
          });
    } catch (e) {
      print('Erro ao sincronizar: $e');
    }
  }

  /// Carrega competições do Firebase
  Future<List<Competition>> loadCompetitions() async {
    try {
      final user = _auth.currentUser;
      if (user == null) return [];

      final snapshot = await _firestore
          .collection('users')
          .doc(user.uid)
          .collection('competitions')
          .get();

      return snapshot.docs.map((doc) {
        // Converter documento para Competition
        return Competition(
          id: doc.id,
          name: doc['name'],
          date: (doc['date'] as Timestamp).toDate(),
          totalRaces: doc['totalRaces'],
          // ... resto da conversão
        );
      }).toList();
    } catch (e) {
      print('Erro ao carregar: $e');
      return [];
    }
  }
}
```

### 7. Autenticação (Opcional)

```dart
// lib/presentation/screens/login_screen.dart

import 'package:firebase_auth/firebase_auth.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;

  Future<void> _login() async {
    setState(() => _isLoading = true);
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );
      // Navegar para home
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.message ?? 'Erro de autenticação')),
      );
    }
    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(hintText: 'Email'),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _passwordController,
              decoration: const InputDecoration(hintText: 'Senha'),
              obscureText: true,
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _login,
                child: _isLoading
                    ? const CircularProgressIndicator()
                    : const Text('Login'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
```

### 8. Sincronização Automática

```dart
// lib/data/repositories/sync_manager.dart

class SyncManager {
  final CompetitionProvider _competitionProvider;
  final FirebaseCompetitionRepository _firebaseRepo;

  SyncManager({
    required CompetitionProvider competitionProvider,
    required FirebaseCompetitionRepository firebaseRepo,
  })
      : _competitionProvider = competitionProvider,
        _firebaseRepo = firebaseRepo;

  /// Inicia sincronização automática
  void startAutoSync() {
    Timer.periodic(const Duration(minutes: 5), (_) async {
      await _syncAll();
    });
  }

  /// Sincroniza todas as competições
  Future<void> _syncAll() async {
    final competitions = _competitionProvider.getAllCompetitions();
    for (final competition in competitions) {
      await _firebaseRepo.syncCompetition(competition);
    }
  }
}
```

## 📊 Monitoramento

- Firebase Console > Firestore Database
- Veja documento em tempo real
- Monitore uso de leitura/escrita
- Configure alertas de quota

## 🔒 Segurança

✅ Sempre use HTTPS
✅ Valide dados no Firestore
✅ Implemente rate limiting
✅ Nunca exponha API keys
✅ Use variáveis de ambiente

## 📝 Notas

- Firebase tem limite gratuito (50k leituras/dia)
- Considere cache local + sync
- Teste bem antes de produção
- Implemente fallback offline

---

**Versão**: 1.0.0
**Data**: Jul/2024
