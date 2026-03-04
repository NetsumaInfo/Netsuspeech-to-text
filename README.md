# Netsuspeech

Netsuspeech est une application de transcription vocale locale construite avec Tauri.

Le but est simple :
- lancer une transcription avec un raccourci global
- parler
- insérer le texte dans l'application active
- garder un fonctionnement local autant que possible

Le projet est maintenu ici :
- code source : `https://github.com/NetsumaInfo/Netsuspeech-to-text`
- releases : `https://github.com/NetsumaInfo/Netsuspeech-to-text/releases`

## Fonctionnalités

- transcription locale avec plusieurs moteurs
- support de Whisper avec accélération GPU quand disponible
- support de Parakeet et d'autres modèles intégrés
- raccourcis globaux configurables
- mode appuyer-pour-parler ou bascule
- post-traitement IA optionnel
- historique des transcriptions
- application Windows, macOS et Linux

## Installation

1. Téléchargez la dernière release depuis `https://github.com/NetsumaInfo/Netsuspeech-to-text/releases`.
2. Installez l'application.
3. Lancez Netsuspeech.
4. Accordez les permissions nécessaires selon votre système.
5. Choisissez votre modèle de transcription.

## Mise à jour automatique

L'application vérifie les mises à jour depuis vos releases GitHub :

- `https://github.com/NetsumaInfo/Netsuspeech-to-text/releases/latest/download/latest.json`

La configuration de l'updater se trouve dans [src-tauri/tauri.conf.json](src-tauri/tauri.conf.json).

Points importants :
- les releases doivent être signées par Tauri
- la `pubkey` de [src-tauri/tauri.conf.json](src-tauri/tauri.conf.json) doit correspondre à la clé privée utilisée en CI
- si vous changez de clé de signature, il faut aussi mettre à jour cette `pubkey`

Le workflow de publication est défini dans [.github/workflows/release.yml](.github/workflows/release.yml) et le build multi-plateforme dans [.github/workflows/build.yml](.github/workflows/build.yml).

## Développement

Pré-requis :
- Rust stable
- Bun
- sur Windows : LLVM, Vulkan SDK et CMake

Installer les dépendances :

```bash
bun install
```

Lancer l'application en développement :

```bash
bun run tauri dev
```

Build frontend :

```bash
bun run build
```

Build desktop :

```bash
bun run tauri build
```

### Windows

Un script de lancement est fourni à la racine :

```powershell
.\launch-app.bat
```

Il prépare les prérequis Windows les plus courants avant de lancer l'application.

## Architecture

Frontend :
- React
- TypeScript
- Vite

Backend :
- Rust
- Tauri

Dossiers utiles :
- [src](src) : interface React
- [src-tauri/src](src-tauri/src) : backend Rust
- [src-tauri/tauri.conf.json](src-tauri/tauri.conf.json) : configuration de l'application et de l'updater
- [.github/workflows/release.yml](.github/workflows/release.yml) : publication des releases

## Notes

- le projet provient d'un fork de Handy, mais le branding, l'identifiant d'application et les releases actives sont maintenant ceux de Netsuspeech
- certains noms internes historiques peuvent encore exister dans le code sans impact fonctionnel
- certains modèles sont encore téléchargés depuis les URLs utilisées par le fork d'origine

## Contribution

1. Forkez le dépôt.
2. Créez une branche.
3. Faites vos modifications.
4. Testez la build.
5. Ouvrez une pull request.

## Licence

MIT. Voir [LICENSE](LICENSE).
