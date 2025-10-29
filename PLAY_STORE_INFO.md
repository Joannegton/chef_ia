# 📱 Chef IA - Informações para Play Store

## ✅ App Bundle Pronto para Envio

**Localização do arquivo:**
```
build/app/outputs/bundle/release/app-release.aab
```

**Tamanho:** 63.91 MB  
**Assinatura:** Produção (Release)  
**Data:** 29/10/2025 20:42:13  
**Alias da chave:** chef_ia

---

## 🔐 Informações de Assinatura

- **Keystore:** `android/chef_ia_key.jks`
- **Alias:** `chef_ia`
- **Algoritmo:** RSA 2048-bit
- **Válido por:** 10950 dias (30 anos)

⚠️ **IMPORTANTE:** Guarde a senha do keystore em local seguro! (senha padrão)

---

## 📤 Como Enviar para Google Play Store

### 1. Acessar Google Play Console
- Acesse: https://play.google.com/console
- Entre com sua conta Google

### 2. Selecionar o App
- Clique no seu aplicativo "Chef IA"
- Vá para: **Release** → **Production** (ou **Testing** para primeiro teste)

### 3. Upload do Bundle
- Clique em **Upload new release**
- Selecione o arquivo: `app-release.aab`
- Clique em **Review**

### 4. Preencher Informações
- **Release notes:** Descreva o que mudou nesta versão
- **Screenshots:** Adicione capturas de tela do app
- **Ícone:** 512x512 px
- **Descrição breve:** Até 80 caracteres
- **Descrição completa:** Até 4000 caracteres

### 5. Política de Privacidade
- **URL da política:** Configure antes de publicar
- **Dados coletados:** Especifique (Localização, Câmera, Fotos, etc.)

### 6. Classificação Etária
- Preencha o formulário de classificação

### 7. Revisar e Publicar
- Revise todas as informações
- Clique em **Start rollout to Production**

---

## 🧪 Teste Antes de Publicar

Se quiser testar primeiro:

1. **Teste Interno:**
   ```
   Release → Internal testing → Upload app-release.aab
   ```

2. **Beta Testing:**
   ```
   Release → Closed testing → Upload app-release.aab
   ```

3. **Instalação Local (para testes):**
   ```powershell
   adb install-multiple build/app/outputs/bundle/release/app-release.aab
   ```

---

## 📋 Checklist Final Antes de Publicar

- [ ] App Bundle verificado (63.91 MB)
- [ ] Assinatura de produção confirmada
- [ ] App testado no emulador/device
- [ ] Screenshots preparados (mínimo 2)
- [ ] Descrição em português preenchida
- [ ] Política de privacidade pronta
- [ ] Categoria selecionada (Lifestyle/Food)
- [ ] Preço definido (Gratuito ou pago)
- [ ] Permissões revisadas (Câmera, Fotos, Localização)

---

## 📧 Contato de Suporte

- **Email:** joannegton@gmail.com
- **GitHub:** https://github.com/Joannegton

---

## 🔄 Para Atualizar o App Depois

Quando quiser lançar uma nova versão:

1. Atualize o `versionCode` e `versionName` em `android/app/build.gradle.kts`
2. Execute:
   ```powershell
   $env:KEY_ALIAS = "chef_ia"
   $env:KEY_PASSWORD = "senha-padrao"
   $env:KEYSTORE_PATH = "android/chef_ia_key.jks"
   $env:KEYSTORE_PASSWORD = "senha-padrao"
   flutter build appbundle --release --dart-define=SUPABASE_ANON_KEY=sua-chave
   ```
3. Upload do novo `app-release.aab` no Play Console

---

**Status:** ✅ Pronto para Play Store!
