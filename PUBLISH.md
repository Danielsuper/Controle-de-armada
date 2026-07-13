# Controle de Armada - Guia de Publicação

## Google Play (Android)

### Pré-requisitos
- Android Studio
- JDK 11+
- Conta Google Play Developer
- Assinatura ativa ($25)

### Passos

1. **Gerar Chave de Assinatura**
```bash
keytool -genkey -v -keystore ~/android_key.jks -keyalg RSA -keysize 2048 -validity 10000 -alias android_key
```

2. **Configurar Assinatura no Gradle**

Crie `android/key.properties`:
```properties
storePassword=<sua_senha>
keyPassword=<sua_senha>
keyAlias=android_key
storeFile=<caminho_para_android_key.jks>
```

3. **Build para Release**
```bash
flutter build appbundle --release
```

4. **Upload na Google Play Console**
- Vá para: https://play.google.com/console
- Crie um novo app
- Carregue o arquivo `.aab` em "Test Track" > "Beta"
- Configure os detalhes do app
- Envie para review

## App Store (iOS)

### Pré-requisitos
- Mac com Xcode
- Conta Apple Developer ($99/ano)
- iPhone para testes

### Passos

1. **Configurar Identidade**

Abra `ios/Runner.xcworkspace`:
```bash
open ios/Runner.xcworkspace
```

2. **Configurar Signing**
- Selecione target "Runner"
- Vá em "Signing & Capabilities"
- Selecione sua conta Apple
- Configure bundle identifier

3. **Build para Release**
```bash
flutter build ios --release
```

4. **Enviar para TestFlight**
```bash
cd ios
xcodebuild -workspace Runner.xcworkspace -scheme Runner -configuration Release -archivePath build/Runner.xcarchive archive
```

5. **Upload no App Store Connect**
- Vá para: https://appstoreconnect.apple.com
- Use Xcode Cloud ou transporter
- Configure informações do app
- Envie para review

## Microsoft Store (Windows)

### Pré-requisitos
- Windows 10+
- Conta Microsoft Partner
- Certificado de assinatura

### Passos

1. **Build para Windows**
```bash
flutter build windows --release
```

2. **Empacotar MSIX**
```bash
flutter pub global activate msix
msix create
```

3. **Assinar Pacote**
Use ferramentas da Microsoft para assinar o `.msix`

4. **Upload no Microsoft Store**
- Vá para: https://partner.microsoft.com
- Crie um novo app
- Carregue o pacote MSIX
- Configure informações
- Envie para review

## Versão e Versionamento

### Incrementar Versão

**pubspec.yaml:**
```yaml
version: 1.0.0+1  # major.minor.patch+build
```

**Android (build.gradle):**
```gradle
versionCode 1
versionName "1.0.0"
```

**iOS (Info.plist):**
```xml
<key>CFBundleShortVersionString</key>
<string>1.0.0</string>
<key>CFBundleVersion</key>
<string>1</string>
```

## Checklist pré-publicação

- [ ] Teste em dispositivo real
- [ ] Verifique performance
- [ ] Teste modo offline
- [ ] Valide saving/loading de dados
- [ ] Teste exportação PDF/Excel
- [ ] Verifique temas claro/escuro
- [ ] Teste navegação
- [ ] Revise screenshots
- [ ] Escreva descrição clara
- [ ] Configure categoria apropriada
- [ ] Revise política de privacidade
- [ ] Valide permições necessárias

## Política de Privacidade

Nota: O aplicativo armazena dados localmente no dispositivo. Não coleta informações pessoais (quando offline).

Prepare uma página em: `https://seu-site.com/privacidade`

## Suporte Pós-Lançamento

- Responda reviews
- Monitorize crashes
- Atualize regularmente
- Corrija bugs reportados
- Implemente sugestões de usuários

---

**Versão**: 1.0.0
**Data de Publicação**: Jul/2024
