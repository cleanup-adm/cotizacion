# Decegar SRL — Sistema de Gestión Clean Up

## Archivos del proyecto
- `public/index.html` — Sistema interno (login, cotizaciones, historial, caja, CRM)
- `public/portal.html` — Portal de clientes (solicitudes de cotización)
- `schema.sql` — Ejecutar en Supabase SQL Editor PRIMERO
- `vercel.json` — Configuración de Vercel

## Instrucciones de despliegue

### PASO 1: Configurar Supabase
1. Ve a https://supabase.com → Tu proyecto
2. Click en "SQL Editor" en el menú izquierdo
3. Pega el contenido de `schema.sql` y ejecuta
4. Ve a Authentication → Users → "Add user" → "Create new user"
   - Email: denichel_2007@hotmail.com | Password: admin123
   - Email: cleanup.pc@hotmail.com | Password: super123
5. Luego en SQL Editor ejecuta esto para dar roles:
   ```sql
   -- Reemplaza los UUIDs con los que aparecen en Authentication > Users
   INSERT INTO public.profiles (id, name, role, email) VALUES
   ('UUID-DE-DENICHEL', 'Denichel Ceballos', 'admin', 'denichel_2007@hotmail.com'),
   ('UUID-DEL-SUPERVISOR', 'Supervisor', 'supervisor', 'cleanup.pc@hotmail.com');
   ```

### PASO 2: Subir a Vercel
**Opción A — Drag & Drop (más fácil):**
1. Ve a https://vercel.com → Dashboard → "Add New Project"
2. Click en "Browse" o arrastra la carpeta `decegar-app`
3. Click "Deploy" — Vercel detecta todo automáticamente
4. En 2 minutos tienes tu URL

**Opción B — GitHub:**
1. Sube la carpeta a GitHub
2. Conecta el repo en Vercel

### PASO 3: Verificar
- Sistema interno: https://tu-url.vercel.app
- Portal clientes: https://tu-url.vercel.app/cotiza

## Usuarios
- Admin: denichel_2007@hotmail.com / admin123
- Supervisor: cleanup.pc@hotmail.com / super123

## Soporte
cleanup.pc@hotmail.com | +1 (829) 956-9526
