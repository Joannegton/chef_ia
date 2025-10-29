# 🚀 Instruções de Build para Produção

## 📱 Build para Play Store (Release)

### Opção 1: Com Variáveis de Ambiente (Recomendado)

```powershell
$supabaseUrl = "https://xmslymknvycpazjupthf.supabase.co"
$supabaseKey = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Inhtc2x5bWtudnljcGF6anVwdGhmIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjE2ODAxNzUsImV4cCI6MjA3NzI1NjE3NX0.7qyCrboETED-vp-XIlrZ2hCbeY-ofuftHw0k412WRoM"

flutter build appbundle --release `
  --dart-define=SUPABASE_URL=$supabaseUrl `
  --dart-define=SUPABASE_ANON_KEY=$supabaseKey
```

### Opção 2: Sem Variáveis (Usa valores padrão do código)

```powershell
flutter build appbundle --release
```

### Opção 3: APK para Testes (em vez de App Bundle)

```powershell
flutter build apk --release `
  --dart-define=SUPABASE_URL=https://xmslymknvycpazjupthf.supabase.co `
  --dart-define=SUPABASE_ANON_KEY=sua-chave-aqui
```

## 📍 Localizações dos Artefatos

- **App Bundle (Play Store):** `build/app/outputs/bundle/release/app-release.aab`
- **APK (Debug/Testes):** `build/app/outputs/flutter-apk/app-release.apk`

## 🔐 Segurança

- ✅ Credenciais Supabase podem ser passadas via `--dart-define` (não ficam no código)
- ✅ Use a chave **ANON** (pública), nunca a **SERVICE_ROLE_KEY** (secreta)
- ✅ Configure **Row Level Security (RLS)** no Supabase para proteção adicional
- ✅ Valide permissões de usuário no banco de dados

## 🧪 Testar em Produção no Emulador

```powershell
flutter run --release
```

## 📦 Upload para Play Store

1. Entre no Google Play Console
2. Vá para Release → Teste Interno/Beta/Produção
3. Upload do arquivo `.aab` (App Bundle)
4. Configure screenshots, descrição, etc.
5. Envie para revisão

## ⚙️ Configuração no Railway (Backend)

```env
NODE_ENV=production
CORS_ORIGINS=https://chefia-online.vercel.app
PORT=3000
```

## 🔍 Verificação Pré-Deploy

- ✅ Backend está rodando no Railway
- ✅ CORS configurado corretamente
- ✅ Supabase RLS habilitado
- ✅ Variáveis de ambiente definidas
- ✅ App foi testado em `flutter run --release`
- ✅ Certificado de signing do Android configurado

---

**Documentação:** [Flutter Build Release](https://docs.flutter.dev/deployment/android)
