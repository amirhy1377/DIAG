# UI Localization Guide

This project ships the Flutter client with five bundled locales (English, Persian, Arabic, Russian, Chinese). Use this guide when you add or review translations.

## Editing Translations
- Source strings live in `ui/flutter/lib/l10n/app_en.arb`.
- One ARB file per locale (`app_<locale>.arb`). Keep keys identical across locales.
- After changing any ARB file, run `flutter pub get` (or `flutter gen-l10n`) from `ui/flutter` to regenerate the `AppLocalizations` classes.
- Prefer descriptive sentences over abbreviations. If a value includes a placeholder, mirror the `{placeholder}` token in every language.

## Review Checklist
1. **Functional:** launch the Flutter app, switch the device locale, and confirm each screen renders (Dashboard, Telemetry, Logs).
2. **Layout:** verify long translations still fit within buttons/cards. Adjust copy or widget constraints where required.
3. **Consistency:** reuse terminology for repeated concepts (session, adapter, telemetry, logs). Update the glossary below when vocabulary changes.
4. **RTL:** test right-to-left locales (Arabic, Persian) to ensure text alignment, icons, and navigation rails behave correctly.

## Adding a New Locale
1. Copy `app_en.arb` to `app_<locale>.arb` and translate the values.
2. Append the locale code to `supportedLocales` in `l10n.yaml` if needed.
3. Regenerate localizations and run `flutter analyze && flutter test`.
4. Update this document with any new vocabulary guidance.

## Glossary
| Concept            | EN  | FA                     | AR                      | RU                         | ZH              |
|-------------------|-----|------------------------|-------------------------|----------------------------|-----------------|
| Session           | Session | نشست                | جلسة                    | Сеанс                     | 会话            |
| Adapter           | Adapter | مبدل               | المحوّل                 | Адаптер                    | 适配器          |
| Telemetry         | Telemetry | تله‌متری         | القياسات                | Телеметрия                 | 遥测            |
| Logs              | Logs | گزارش‌ها             | السجلات                 | Журналы                    | 日志            |

Keep the glossary in sync with translations to reduce drift between locales.
