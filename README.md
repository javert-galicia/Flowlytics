# Flowlytics

Una aplicación Flutter que permite crear y gestionar herramientas de análisis empresarial como Business Model Canvas, FODA y Value Proposition Canvas.

## Características

- ✅ Interfaz de usuario responsive que se adapta a móvil y desktop
- ✅ 9 secciones del Business Model Canvas tradicional
- ✅ Persistencia local usando SharedPreferences
- ✅ Colores temáticos por área:
  - **Azul** - Infraestructura (Key Partners, Key Activities, Key Resources)
  - **Verde** - Oferta (Value Propositions)
  - **Naranja** - Clientes (Customer Relationships, Channels, Customer Segments)
  - **Púrpura** - Finanzas (Cost Structure, Revenue Streams)
- ✅ Añadir y eliminar elementos de cada sección
- ✅ Diseño Material 3

## Diferencias con la versión React

### Características removidas/simplificadas:
- **Drag & Drop**: La funcionalidad de arrastrar y soltar no está implementada en esta versión
- **TailwindCSS**: Reemplazado por el sistema de temas nativo de Flutter
- **CSS Grid**: Reemplazado por el sistema de layout de Flutter (Row/Column/Expanded)

### Mejoras:
- **Mejor responsive design**: Se adapta automáticamente entre vista móvil (vertical) y desktop (grid)
- **Persistencia más robusta**: Usa SharedPreferences en lugar de localStorage
- **Mejor gestión de estado**: Estado centralizado con setState
- **Tema consistente**: Material Design 3

## Instalación y ejecución

### Prerrequisitos
- Flutter SDK instalado
- Dart SDK (incluido con Flutter)

### Pasos

1. **Instalar dependencias**:
   ```bash
   cd flowlytics
   flutter pub get
   ```

2. **Ejecutar la aplicación**:
   ```bash
   flutter run
   ```

3. **Para web**:
   ```bash
   flutter run -d chrome
   ```

4. **Para móvil** (con dispositivo/emulador conectado):
   ```bash
   flutter run
   ```

## Estructura del proyecto

```
lib/
├── main.dart                 # Punto de entrada y pantalla principal
├── models/
│   └── canvas_models.dart    # Modelos de datos (BusinessModelCanvas, CanvasBlock, etc.)
└── widgets/
    └── canvas_section.dart   # Widget para cada sección del canvas
```

## Dependencias

- `flutter`: Framework principal
- `shared_preferences`: Persistencia local
- `reorderables`: (Preparado para futuras funcionalidades de reordenamiento)

## Comparación con la versión React

| Característica | React | Flutter |
|----------------|-------|---------|
| Drag & Drop | ✅ @dnd-kit | ❌ (pendiente) |
| Responsive | ✅ TailwindCSS | ✅ LayoutBuilder |
| Persistencia | ✅ localStorage | ✅ SharedPreferences |
| Gestión Estado | ✅ useState | ✅ setState |
| Tema/Colores | ✅ TailwindCSS | ✅ Material Theme |
| Plataformas | 🌐 Web | 📱 Móvil + 🌐 Web + 💻 Desktop |

## Próximas mejoras

- [ ] Implementar drag & drop para reordenar secciones
- [ ] Añadir funcionalidad de exportar/importar
- [ ] Añadir validaciones de entrada
- [ ] Mejoras en la UI/UX
- [ ] Modo oscuro
- [ ] Múltiples canvas guardados
