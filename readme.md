# Funeral Home Management System - Installer

## Opis projektu

Aplikacja zarządzania zakładem pogrzebowym zbudowana w technologii **React + Spring Boot + H2 Database**. Installer umożliwia dystrybucję aplikacji jako standalone executable bez konieczności instalacji dodatkowych zależności na komputerze użytkownika końcowego.

## 🏗Architektura rozwiązania

### Backend
- **Spring Boot 3.x** - framework aplikacyjny
- **H2 Database** - embedded baza danych (zastąpiono MySQL dla portable)
- **Spring Security + JWT** - autoryzacja i uwierzytelnianie
- **iText PDF** - generowanie raportów

### Frontend
- **React 19** - interfejs użytkownika
- **Vite** - build tool
- **Tailwind CSS** - stylowanie
- **React Router** - routing

### Standalone Package
- **Embedded JRE 17** - portable Java Runtime Environment
- **H2 File Database** - lokalna baza danych w folderze `data/`
- **WinRAR SFX** - self-extracting executable installer

## Modyfikacje dla Installer

### 1. Zmiana bazy danych z MySQL na H2

#### `pom.xml` - zależności:
```xml
<!-- Usunięto MySQL -->
<!-- <dependency>
    <groupId>com.mysql</groupId>
    <artifactId>mysql-connector-j</artifactId>
    <scope>runtime</scope>
</dependency> -->

<!-- Dodano H2 -->
<dependency>
    <groupId>com.h2database</groupId>
    <artifactId>h2</artifactId>
    <scope>runtime</scope>
</dependency>
```

#### `application.properties`:
```properties
# H2 Database Configuration (zamiast MySQL)
spring.datasource.url=jdbc:h2:file:./data/funeral_home;DB_CLOSE_DELAY=-1;DB_CLOSE_ON_EXIT=FALSE
spring.datasource.username=sa
spring.datasource.password=
spring.datasource.driver-class-name=org.h2.Driver
spring.jpa.database-platform=org.hibernate.dialect.H2Dialect
spring.jpa.hibernate.ddl-auto=update

# H2 Console (debugging)
spring.h2.console.enabled=true
spring.h2.console.path=/h2-console

# Static Resources dla React SPA
spring.web.resources.static-locations=classpath:/static/
spring.mvc.static-path-pattern=/**
```

### 2. Konfiguracja React SPA w Spring Boot

#### `SpaController.java`:
```java
@Controller
public class SpaController {
    // Forward wszystkie route'y do index.html dla React Router
    @RequestMapping(value = {"/", "/log", "/admin", "/profile", "/tasks", "/raports", "/recepcionist"})
    public String forward() {
        return "forward:/index.html";
    }
}
```

#### `SecurityConfig.java` - pozwolenie na static files:
```java
.authorizeHttpRequests(auth -> auth
    // Pozwól na wszystkie static resources (React frontend)
    .requestMatchers("/", "/index.html", "/static/**", "/assets/**", 
                   "/*.js", "/*.css", "/*.png", "/*.jpg", "/*.gif", 
                   "/*.ico", "/*.svg", "/vite.svg").permitAll()
    // ... reszta konfiguracji
)
```

### 3. Frontend - jednolite URL-e API

Wszystkie fetch() w React używają pełnych URL-i:
```javascript
// Przykład z Login.jsx
const response = await fetch('http://localhost:8080/auth/login', {
    method: 'POST',
    headers: {
        'Content-Type': 'application/json',
    },
    body: JSON.stringify({
        email,
        passwordHash: password,
    }),
});
```

## 🚀 Proces buildowania

### 1. Build skrypty

#### `build-frontend.bat`:
```batch
# Buduje React frontend i kopiuje do src/main/resources/static/
cd frontend-next
npm install
npm run build
xcopy /E /I /Y "dist\*" "..\src\main\resources\static\"
```

#### `final-build.bat`:
```batch
# Kompletny build: frontend + backend + dystrybucja
1. Buduje React frontend
2. Kopiuje do Spring Boot static folder
3. Kompiluje Spring Boot z embedded frontendem
4. Kopiuje JAR do dist/
5. Kopiuje JRE do dist/jre/
6. Tworzy start.bat i stop.bat
```

### 2. Struktura dystrybucji

Po uruchomieniu `final-build.bat`:
```
dist/
├── app.jar                 # Spring Boot z embedded React
├── jre/                    # Portable Java Runtime Environment 17
│   ├── bin/java.exe
│   └── ...
├── start.bat              # Skrypt uruchamiający
├── stop.bat               # Skrypt zatrzymujący  
├── data/                  # Folder bazy danych H2 (tworzony automatycznie)
└── README.txt             # Instrukcje użytkownika
```

## Tworzenie Installer

### 1. Przygotowanie plików

```batch
create-simple-installer.bat
```

Tworzy folder `installer/` z:
- Aplikacją z embedded JRE
- Skryptami instalacyjnymi
- README z instrukcjami

### 2. WinRAR SFX Installer

#### Konfiguracja SFX (`sfx-config.txt`):
```ini
Path=%ProgramFiles%\Funeral Home Management System
Setup=SETUP.bat
Silent=0
Overwrite=1
Title=Funeral Home Management System Installer
Text=System zarządzania zakładem pogrzebowym...
```

#### Proces tworzenia:
1. Zaznacz wszystkie pliki w folderze `installer/`
2. Prawym klawiszem → "Add to archive"
3. Format: RAR
4. ✅ "Create SFX archive"
5. Advanced → SFX options → Setup tab: `SETUP.bat`
6. OK → powstaje `FuneralHome-Setup.exe`

## Użycie końcowe

### Dla użytkownika końcowego:

1. **Pobiera:** `FuneralHome-Setup.exe` (jeden plik)
2. **Uruchamia:** Dwuklik na pliku
3. **Instalacja:** Automatyczna ekstraktacja do Program Files
4. **Skrót:** Tworzy się "Funeral Home" na pulpicie
5. **Uruchomienie:** Aplikacja startuje automatycznie
6. **Dostęp:** http://localhost:8080

### Domyślne konta:

#### Administratorzy:
- `faustyna@zaklad.pl` / `admin`
- `michal@zaklad.pl` / `admin`
- `mateusz_h@zaklad.pl` / `admin`
- `mateusz_f@zaklad.pl` / `admin`

#### Pracownicy:
- `prac1@zaklad.pl` / `user`
- `prac2@zaklad.pl` / `user`
- `prac3@zaklad.pl` / `user`

## Rozwój i debugging

### Development mode:
```bash
# Terminal 1 - Backend
mvnw spring-boot:run

# Terminal 2 - Frontend  
cd frontend-next
npm run dev
```

### Production mode:
```bash
cd dist
start.bat
```

### H2 Database Console:
- URL: http://localhost:8080/h2-console
- JDBC URL: `jdbc:h2:file:./data/funeral_home`
- Username: `sa`
- Password: (empty)

## Struktura projektu

```
INF_CZARNI/
├── src/main/java/zaklad/pogrzebowy/api/
│   ├── controllers/         # REST API endpoints
│   ├── models/             # JPA entities
│   ├── services/           # Business logic
│   ├── repositories/       # Data access
│   ├── security/           # JWT + Spring Security
│   └── config/            # Configuration classes
├── src/main/resources/
│   ├── static/            # React build output (generated)
│   └── application.properties
├── frontend-next/
│   ├── src/               # React source code
│   ├── public/            # Static assets
│   └── dist/              # Build output
├── jre-portable/          # Downloaded JRE for packaging
├── dist/                  # Final distribution
├── installer/             # Prepared for SFX
└── build scripts/         # Automation scripts
```

## 🔧 Wymagania deweloperskie

### Do developmentu:
- **Java 17+** JDK
- **Node.js 18+** + npm
- **Maven 3.8+** (lub mvnw wrapper)
