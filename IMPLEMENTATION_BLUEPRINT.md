# **Lumina ERD Generator - Flutter App Development Blueprint**

# **🔷 PHASE 1: Project Initialization & Architecture Setup**

```
PROMPT:
Create a Flutter project named "lumina_erd_generator" with the following structure and dependencies:

Project Structure:

lib/
├── main.dart
├── app.dart
├── core/
│   ├── constants/
│   │   └── app_constants.dart
│   ├── theme/
│   │   └── app_theme.dart
│   ├── utils/
│   │   ├── file_utils.dart
│   │   └── string_utils.dart
│   └── errors/
│       └── app_exceptions.dart
├── features/
│   ├── project_loader/
│   │   ├── presentation/
│   │   │   ├── screens/
│   │   │   └── widgets/
│   │   ├── domain/
│   │   │   ├── models/
│   │   │   └── repositories/
│   │   └── data/
│   │       └── datasources/
│   ├── schema_parser/
│   │   ├── domain/
│   │   │   ├── models/
│   │   │   └── services/
│   │   └── data/
│   │       └── parsers/
│   ├── erd_viewer/
│   │   ├── presentation/
│   │   │   ├── screens/
│   │   │   └── widgets/
│   │   └── domain/
│   │       └── models/
│   └── export/
│       ├── presentation/
│       │   ├── screens/
│       │   └── widgets/
│       ├── domain/
│       │   └── services/
│       └── data/
│           └── exporters/
└── shared/
    └── widgets/

Dependencies to add in pubspec.yaml:
- file_picker: ^6.1.1
- path: ^1.8.3
- glob: ^2.1.2
- share_plus: ^7.2.1
- webview_flutter: ^4.4.2
- flutter_riverpod: ^2.4.9
- freezed_annotation: ^2.4.1
- json_annotation: ^4.8.1
- uuid: ^4.2.1

Dev Dependencies:
- build_runner: ^2.4.7
- freezed: ^2.4.6
- json_serializable: ^6.7.1
- flutter_lints: ^3.0.1

Use Riverpod for state management.
Use Freezed for immutable models.
Use clean architecture with feature-first approach.
```

---

# **🔷 PHASE 2: Core Data Models**

```
PROMPT:
Create the core data models for the Lumina ERD Generator app using Freezed.
These models represent the parsed database schema.

Create the following files:

1. lib/features/schema_parser/domain/models/table_schema.dart
   - TableSchema class with fields: id (String), name (String), columns (List<ColumnSchema>), indexes (List<IndexSchema>)
   - Include factory constructor fromJson/toJson

2. lib/features/schema_parser/domain/models/column_schema.dart
   - ColumnSchema class with fields: name (String), type (String), nullable (bool), unique (bool), primary (bool), default_value (String?), length (int?), unsigned (bool)
   - Support Laravel column types: id, bigIncrements, string, text, integer, bigInteger, boolean, date, datetime, timestamp, json, enum, float, decimal

3. lib/features/schema_parser/domain/models/relationship_schema.dart
   - RelationshipSchema class with fields: type (enum: belongsTo, hasMany, hasOne, belongsToMany), sourceTable (String), targetTable (String), foreignKey (String?), localKey (String?), pivotTable (String?)
   - Include a method to determine if relationship is from migration (has explicit FK) or from model inference

4. lib/features/schema_parser/domain/models/project_schema.dart
   - ProjectSchema class with fields: projectName (String), tables (List<TableSchema>), relationships (List<RelationshipSchema>)
   - Include a method to check if relationships are from migrations only or need model parsing

Use @freezed annotation for all models.
Add proper JSON serialization.
Add validation logic for table/column naming conventions.
```

---

# **🔷 PHASE 3: Migration File Parser**

```
PROMPT:
Create a Laravel migration file parser that extracts table structure and foreign keys from PHP migration files.

Create: lib/features/schema_parser/data/parsers/migration_parser.dart

The parser should:
1. Scan all .php files in database/migrations/ directory
2. Extract table names from Schema::create('table_name', ...)
3. Parse column definitions inside the closure:
   - $table->id() → bigint auto-increment primary
   - $table->string('name', 255) → varchar
   - $table->text('body')->nullable() → text nullable
   - $table->foreignId('user_id')->constrained() → FK to users.id
   - $table->foreign('user_id')->references('id')->on('users') → explicit FK
   - $table->timestamps() → created_at, updated_at timestamps
   - $table->softDeletes() → deleted_at timestamp
4. Extract foreign key relationships from:
   - foreignId()->constrained()
   - foreign()->references()->on()
   - Foreign key constraints in Schema::table() for ALTER TABLE

Use regex patterns for PHP code parsing.
Handle multi-line closures properly.
Skip migration files that don't create/alter tables.
Return ProjectSchema with tables and relationships from migrations.
Include error handling for malformed migration files.

Bonus: Parse Schema::table() for additional FK constraints added after table creation.
```

---

# **🔷 PHASE 4: Model Relationship Parser**

```
PROMPT:
Create a Laravel model file parser that infers relationships when foreign keys are not explicitly defined in migrations.

Create: lib/features/schema_parser/data/parsers/model_parser.dart

The parser should:
1. Scan all .php files in app/Models/ directory
2. For each model, extract relationship methods:
   - public function posts() { return $this->hasMany(Post::class); }
   - public function user() { return $this->belongsTo(User::class); }
   - public function profile() { return $this->hasOne(Profile::class); }
   - public function roles() { return $this->belongsToMany(Role::class); }
3. Infer foreign keys using Laravel conventions when not explicitly stated:
   - belongsTo: snake_case of relationship name + _id
   - hasMany/hasOne: model's foreign key + _id
4. Resolve model class names to table names using Laravel conventions
5. Handle custom table names ($table property) and foreign keys ($foreignKey parameter)

Only run this parser IF:
- ProjectSchema.checkNeedsModelParsing() returns true (no FKs found in migrations)
- User explicitly enables model-based relationship inference

Create a model file scanner with:
- Regex patterns for relationship methods
- Extraction of method name, related model, relationship type
- Proper handling of multi-line method definitions

Return List<RelationshipSchema> from model inferences.
Flag relationships as "inferred" vs "explicit" from migrations.
```

---

# **🔷 PHASE 5: Main Application UI Shell**

```
PROMPT:
Create the main application shell with navigation and state management for the ERD Generator.

Create: lib/app.dart and update lib/main.dart

Main features of the app shell:
1. Material 3 design with a clean, professional theme
2. Three main screens accessible via bottom navigation:
   - Project Loader (folder selection)
   - Schema Viewer (table list & details)
   - ERD Viewer (visual diagram)
3. AppBar with actions:
   - Export menu (dropdown with all 6 formats)
   - Settings (toggle model parsing on/off)
   - About dialog

Create the following screens as placeholders:
- lib/features/project_loader/presentation/screens/project_loader_screen.dart
- lib/features/schema_parser/presentation/screens/schema_viewer_screen.dart
- lib/features/erd_viewer/presentation/screens/erd_viewer_screen.dart

State management with Riverpod:
- Create providers for:
  - selectedDirectory (StateProvider<String?>)
  - projectSchema (StateProvider<ProjectSchema?>)
  - selectedExportFormat (StateProvider<ExportFormat>)
  - enableModelParsing (StateProvider<bool>)
  - isLoading (StateProvider<bool>)
  - parsingProgress (StateProvider<double>)

Create a main.dart that initializes Riverpod and runs the app.
Theme should use:
- Primary: deep indigo
- Surface: light gray
- Use Inter font family
- Consistent spacing and elevation
```

---

# **🔷 PHASE 6: Project Loader Screen**

```
PROMPT:
Create the project loader screen that allows users to select a Laravel project directory.

Create: lib/features/project_loader/presentation/screens/project_loader_screen.dart
Create: lib/features/project_loader/presentation/widgets/folder_picker_widget.dart

Features:
1. Large "Select Laravel Project" button at center
2. After selection, show:
   - Project path with breadcrumb style
   - Detection of Laravel project (check for artisan file, app/Models, database/migrations)
   - Number of migration files found
   - Number of model files found
   - Quick summary: "X tables, Y migrations, Z models detected"
3. "Parse Schema" button to trigger parsing
4. Recent projects list (stored in shared_preferences)
5. Error state if not a valid Laravel project
6. Loading indicator during parsing with progress

The folder picker should use file_picker package to select directories.
Validate the selected directory has Laravel structure.
Store last 5 opened projects in local storage.

Create the widget with:
- Clean card-based layout
- Laravel logo or icon
- Step-by-step indicator: Select → Validate → Parse → View
- Support both mobile and desktop layouts (responsive)
```

---

# **🔷 PHASE 7: Schema Viewer Screen**

```
PROMPT:
Create the schema viewer screen that displays parsed tables, columns, and relationships in a detailed list view.

Create: lib/features/schema_parser/presentation/screens/schema_viewer_screen.dart
Create: lib/features/schema_parser/presentation/widgets/table_card.dart
Create: lib/features/schema_parser/presentation/widgets/column_row.dart
Create: lib/features/schema_parser/presentation/widgets/relationship_badge.dart

Features:
1. Search bar to filter tables by name
2. Sort options: alphabetical, by column count, by relationship count
3. Each table displayed as an expandable card showing:
   - Table name (header)
   - Column count badge
   - Relationship count badge
   - Expand to see columns with:
     - Column name, data type, nullable/unique/primary indicators
     - Color-coded data type badges
     - Default value if set
   - Related tables section showing relationships
4. Legend for data type colors
5. Filter by: has relationships, has primary key, specific data type
6. Toggle between migration-sourced and model-inferred relationships

Design:
- Sticky headers for table name sections
- Alternating row colors for readability
- Icons for column constraints (key for PK, asterisk for required, etc.)
- Smooth expand/collapse animations
- Responsive: list on mobile, grid of cards on tablet/desktop
```

---

# **🔷 PHASE 8: ERD Viewer - Interactive Canvas**

```
PROMPT:
Create the interactive ERD viewer using a custom canvas that allows zoom, pan, and table dragging.

Create: lib/features/erd_viewer/presentation/screens/erd_viewer_screen.dart
Create: lib/features/erd_viewer/presentation/widgets/erd_canvas.dart
Create: lib/features/erd_viewer/presentation/widgets/table_node.dart
Create: lib/features/erd_viewer/presentation/widgets/relationship_line.dart

Features:
1. Interactive canvas with:
   - Pinch to zoom (0.25x to 3x)
   - Pan/drag to navigate
   - Double-tap to fit all tables
   - Table nodes that can be dragged to rearrange
2. Table nodes showing:
   - Table name as header (bold, colored background)
   - Columns listed below (scrollable if many)
   - Primary key with key icon
   - Foreign keys highlighted
   - Relationship count badge
3. Relationship lines between tables:
   - Smooth bezier curves with directional control points
   - Color coding by relationship type:
     - belongsTo: foreignKey color (orange)
     - hasMany: explicitRelation color (indigo)
     - hasOne: info color (blue)
     - belongsToMany: pivotKey color (yellow)
   - Obstacle avoidance — lines route around table nodes
   - Smart edge connection points (connects to nearest table edge)
   - Crow's foot notation for cardinality
   - Line thickness based on highlight state
4. Controls:
   - Zoom slider or +/- buttons
   - Auto-layout button (simple grid or force-directed)
   - Reset view button
   - Toggle relationship visibility
   - Toggle column detail level (compact/full)
5. Interaction:
   - Tap table to highlight its relationships
   - Long press table for context menu (view details, hide, center)
   - Double tap relationship line to see details

Use CustomPainter for the canvas.
Implement LineSegment intersection detection for obstacle avoidance.
Implement force-directed layout algorithm for auto-arrange.
Cache table positions for consistent reloads.
```

---

# **🔷 PHASE 9: Export Engine - All 6 Formats**

```
PROMPT:
Create the export engine that generates ERD outputs in all 6 required formats.

Create the following files:
1. lib/features/export/domain/services/export_service.dart (coordinator)
2. lib/features/export/data/exporters/mermaid_exporter.dart
3. lib/features/export/data/exporters/dbml_exporter.dart
4. lib/features/export/data/exporters/html_exporter.dart
5. lib/features/export/data/exporters/markdown_exporter.dart
6. lib/features/export/data/exporters/plantuml_exporter.dart
7. lib/features/export/data/exporters/graphviz_exporter.dart

Each exporter should take ProjectSchema as input and return String content.

### Mermaid Exporter:
Generate Mermaid ERD syntax:

erDiagram
    USERS ||--o{ POSTS : has
    USERS {
        bigint id PK
        varchar name
        varchar email
    }


### DBML Exporter (for dbdiagram.io):
Generate DBML syntax:

Table users {
  id bigint [pk, increment]
  name varchar(255)
  email varchar(255) [unique]
}
Ref: posts.user_id > users.id

### HTML Exporter (Interactive Artifact):
Generate a self-contained HTML file with:
- Embedded CSS for styling
- Vanilla JavaScript for interactivity
- SVG-based ERD rendering
- Zoom, pan, click-to-highlight functionality
- Responsive design
- Tooltip on hover showing column details
- No external dependencies

### Markdown Data Dictionary:
Generate structured markdown:
- Project name as H1
- Each table as H2
- Column table with name, type, constraints, description
- Relationship summary section
- Legend section
- Generation metadata (date, source)

### PlantUML Exporter:
Generate .puml syntax for ERD diagrams.

### Graphviz Exporter:
Generate .dot syntax with proper node and edge definitions.

### Export Service:
Coordinate exports with:
- Method to export single format
- Method to export all formats as ZIP
- File naming convention: {project_name}_erd.{extension}
- Share functionality using share_plus
- Save to device storage option
```

---

# **🔷 PHASE 10: Export Preview & Share Screen**

```
PROMPT:
Create the export preview and sharing screen.

Create: lib/features/export/presentation/screens/export_screen.dart
Create: lib/features/export/presentation/widgets/format_selector.dart
Create: lib/features/export/presentation/widgets/preview_pane.dart

Features:
1. Format selector with 6 cards in a grid:
   - Mermaid (Markdown)
   - DBML (dbdiagram.io)
   - HTML (Interactive)
   - Markdown (Data Dictionary)
   - PlantUML
   - Graphviz (DOT)
2. Each card shows:
   - Format name and icon
   - File extension
   - Brief description of use case
   - Preview thumbnail or sample output
3. Preview pane:
   - Scrollable code view with syntax highlighting
   - Copy to clipboard button
   - For HTML: "Preview in WebView" button
4. Export options:
   - Save to file (with directory picker)
   - Share via system share sheet
   - Copy to clipboard
   - "Export All as ZIP" option
5. Recent exports history
6. Settings for:
   - Include inferred relationships toggle
   - Column detail level (all / PK+FK only / custom)
   - Diagram direction (top-down / left-right)

Use flutter_highlight or similar for syntax highlighting in preview.
Use webview_flutter for HTML preview.
Use share_plus for sharing files.
```

---

# **🔷 PHASE 11: Settings & Project Configuration**

```
PROMPT:
Create settings screen and project configuration features.

Create: lib/features/settings/presentation/screens/settings_screen.dart
Create: lib/core/services/config_service.dart

Settings options:
1. Parsing Settings:
   - Enable/disable model-based relationship inference
   - Strict mode (only explicit FKs from migrations)
   - Include soft-deleted tables toggle
   - Ignore specific tables (blacklist)
2. Display Settings:
   - Default ERD layout (auto / grid / force-directed)
   - Color scheme for ERD (light / dark / custom)
   - Relationship line style (straight / curved / orthogonal)
   - Notation style (crow's foot / arrow / UML)
3. Export Settings:
   - Default export format
   - Auto-include data dictionary
   - File naming pattern
   - Output directory
4. Data Management:
   - Clear recent projects
   - Clear export cache
   - Export/Import app settings
   - Reset to defaults

Use shared_preferences for persisting settings.
Create a settings provider with Riverpod.
Apply settings immediately without app restart where possible.
Add a settings icon in the AppBar across all screens.
```

---

# **🔷 PHASE 12: Testing & Edge Cases**

```
PROMPT:
Add comprehensive error handling, edge case management, and testing structure.

Create: lib/core/errors/error_handler.dart

Handle these edge cases:
1. Invalid Laravel projects (no artisan file, wrong structure)
2. Empty migration files
3. Malformed PHP syntax in migrations
4. Circular foreign key references
5. Self-referencing relationships
6. Polymorphic relationships (commentable_type/commentable_id)
7. Multiple migrations modifying the same table
8. Tables with no primary key
9. Composite foreign keys
10. Very large projects (100+ tables) - performance optimization
11. Nested directories in app/Models/
12. Custom table names that don't follow convention
13. Pivot tables for many-to-many relationships
14. UUID primary keys vs auto-increment

Error handling approach:
- User-friendly error messages with suggestions
- Graceful degradation (parse what you can, flag what you can't)
- Validation warnings vs. errors
- Error logging for debugging

Testing structure:
- Unit tests for each parser
- Widget tests for each screen
- Integration test for full workflow
- Test fixtures: sample Laravel project structures
- Mock file system for testing parsers

Create test files:
- test/unit/parsers/migration_parser_test.dart
- test/unit/parsers/model_parser_test.dart
- test/unit/exporters/all_exporters_test.dart
- test/widget/erd_viewer_test.dart
- test/integration/full_workflow_test.dart
```

---

# **🔷 PHASE 13: Final Polish & Performance**

```
PROMPT:
Final polish and optimization for the Lumina ERD Generator app.

Tasks:
1. Add onboarding flow:
   - 3-screen intro for first-time users
   - Sample project option for demo
   - Quick tutorial tooltips

2. Performance optimization:
   - Lazy loading for large ERD canvas
   - Debounced search/filter
   - Cached parsing results
   - Optimized canvas repainting
   - Background parsing with isolates for large projects

3. Animations & Micro-interactions:
   - Skeleton loading screens
   - Smooth transitions between screens
   - Ripple effects on table nodes
   - Success confetti on export
   - Haptic feedback on mobile

4. Accessibility:
   - Screen reader labels
   - Sufficient color contrast
   - Keyboard navigation for desktop
   - Scalable text sizes

5. App Icon & Splash Screen:
   - Custom app icon (database + Laravel taylor)
   - Branded splash screen
   - Loading animation

6. Prepare for release:
   - App name: "Lumina ERD Studio"
   - Version: 1.0.0
   - Privacy policy page
   - Rate app prompt after 5 exports
   - Feedback/ bug report option

Generate final build commands:
- flutter build apk --release
- flutter build ios --release
- flutter build macos --release
- flutter build windows --release
```

---

## **📊 Development Timeline Guide**

| Phase | ခန့်မှန်းချိန် | Complexity |
|---|---|---|
| Phase 1-2: Setup & Models | 1-2 hours | Low |
| Phase 3-4: Parsers | 3-4 hours | High |
| Phase 5-7: UI Shell + Viewer | 2-3 hours | Medium |
| Phase 8: ERD Canvas | 3-4 hours | High |
| Phase 9-10: Export Engine | 2-3 hours | Medium |
| Phase 11-12: Settings & Testing | 2-3 hours | Medium |
| Phase 13: Polish | 1-2 hours | Low |

---