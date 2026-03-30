-- DECEGAR SRL -- División Clean Up
-- Schema completo para Supabase
-- Ejecutar en Supabase > SQL Editor

-- USUARIOS (extendemos auth.users de Supabase)
create table if not exists public.profiles (
  id uuid references auth.users on delete cascade primary key,
  name text not null,
  role text not null default 'supervisor' check (role in ('admin','supervisor','secretaria')),
  email text,
  active boolean default true,
  created_at timestamptz default now()
);
alter table public.profiles enable row level security;
create policy "Profiles visibles para usuarios autenticados" on public.profiles
  for select using (auth.role() = 'authenticated');
create policy "Admin puede editar profiles" on public.profiles
  for all using (auth.role() = 'authenticated');

-- CLIENTES
create table if not exists public.clientes (
  id bigserial primary key,
  nombre text not null,
  telefono text,
  direccion text,
  rnc text,
  email text,
  notas text,
  created_at timestamptz default now(),
  updated_at timestamptz default now()
);
alter table public.clientes enable row level security;
create policy "Clientes para autenticados" on public.clientes
  for all using (auth.role() = 'authenticated');

-- COTIZACIONES
create table if not exists public.cotizaciones (
  id bigserial primary key,
  numero text not null unique,
  tipo text not null default 'cot' check (tipo in ('cot','facb','facrnc')),
  status text not null default 'pendiente' check (status in ('pendiente','confirmada','completada','cancelada')),
  cliente_nombre text not null,
  cliente_tel text,
  cliente_dir text,
  cliente_rnc text,
  tecnico text,
  fecha_servicio date,
  fecha_vencimiento date,
  forma_pago text default 'efectivo',
  subtotal numeric(12,2) default 0,
  descuento numeric(12,2) default 0,
  itbis numeric(12,2) default 0,
  total numeric(12,2) default 0,
  anticipo numeric(12,2) default 0,
  saldo numeric(12,2) default 0,
  nota text,
  lineas jsonb default '[]',
  ncf text,
  creado_por uuid references auth.users,
  creado_por_nombre text,
  created_at timestamptz default now(),
  updated_at timestamptz default now()
);
alter table public.cotizaciones enable row level security;
create policy "Cotizaciones para autenticados" on public.cotizaciones
  for all using (auth.role() = 'authenticated');

-- CAJA
create table if not exists public.caja (
  id bigserial primary key,
  tipo text not null check (tipo in ('ingreso','gasto')),
  descripcion text not null,
  monto numeric(12,2) not null,
  categoria text,
  fecha date not null default current_date,
  cotizacion_id bigint references public.cotizaciones,
  registrado_por uuid references auth.users,
  registrado_por_nombre text,
  created_at timestamptz default now()
);
alter table public.caja enable row level security;
create policy "Caja para autenticados" on public.caja
  for all using (auth.role() = 'authenticated');

-- NCF
create table if not exists public.ncf (
  id bigserial primary key,
  numero text not null unique,
  tipo text not null default 'B01',
  usado boolean default false,
  cotizacion_id bigint references public.cotizaciones,
  fecha_uso timestamptz,
  created_at timestamptz default now()
);
alter table public.ncf enable row level security;
create policy "NCF para autenticados" on public.ncf
  for all using (auth.role() = 'authenticated');

-- CONFIG
create table if not exists public.config (
  id int primary key default 1 check (id = 1),
  br_titular text default 'Allyson Bello',
  br_cedula text default '402-2555809-3',
  br_cuenta text default '9605956124',
  br_tipo text default 'Cuenta de ahorros',
  bp_titular text default 'Allyson Bello',
  bp_cedula text default '402-2555809-3',
  bp_cuenta text default '834772287',
  bp_tipo text default 'Cuenta de ahorros',
  tecnico_default text default 'Denichel Ceballos',
  min_alfombra int default 750,
  pin_admin text default '123456',
  cot_counter int default 0,
  updated_at timestamptz default now()
);
alter table public.config enable row level security;
create policy "Config para autenticados" on public.config
  for all using (auth.role() = 'authenticated');

-- Insertar config inicial
insert into public.config (id) values (1) on conflict (id) do nothing;

-- Trigger updated_at
create or replace function public.handle_updated_at()
returns trigger as $$
begin new.updated_at = now(); return new; end;
$$ language plpgsql;

create trigger on_cotizaciones_updated before update on public.cotizaciones
  for each row execute procedure public.handle_updated_at();
create trigger on_config_updated before update on public.config
  for each row execute procedure public.handle_updated_at();

-- PORTAL REQUESTS
create table if not exists public.portal_requests (
  id bigserial primary key,
  nombre text not null,
  telefono text not null,
  direccion text,
  servicios jsonb default '[]',
  total_estimado numeric(12,2) default 0,
  nota text,
  status text default 'nuevo' check (status in ('nuevo','contactado','cotizado','cancelado')),
  created_at timestamptz default now()
);
alter table public.portal_requests enable row level security;
create policy "Portal requests insert publico" on public.portal_requests
  for insert with check (true);
create policy "Portal requests lectura autenticados" on public.portal_requests
  for select using (auth.role() = 'authenticated');
create policy "Portal requests update autenticados" on public.portal_requests
  for update using (auth.role() = 'authenticated');
